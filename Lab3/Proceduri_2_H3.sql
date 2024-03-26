CREATE TABLE Version (
    currentVersion INT
);


INSERT INTO Version (currentVersion) VALUES (1);

CREATE TABLE Versionen (
    VersionNummer INT,
    Prozedur NVARCHAR(MAX),
    Parameter1 VARCHAR(MAX),
    Parameter2 VARCHAR(MAX),
    Parameter3 VARCHAR(MAX),
    Parameter4 VARCHAR(MAX)  
);


CREATE OR ALTER PROCEDURE GoToVersion(@changedVersion INT)
AS
BEGIN
    DECLARE @currentVersion INT;

    DECLARE @procedureName VARCHAR(MAX),
            @TableName VARCHAR(MAX),
            @ColumnName VARCHAR(MAX),
            @Parameter1 VARCHAR(MAX),
            @Parameter2 VARCHAR(MAX),
            @Parameter3 VARCHAR(MAX),
            @Parameter4 VARCHAR(MAX);

    SET @currentVersion = (SELECT currentVersion FROM Version);

    IF (@currentVersion > @changedVersion)
    BEGIN
        BEGIN TRANSACTION;

        WHILE @currentVersion > @changedVersion
        BEGIN
            SELECT @procedureName = v.Prozedur,
                   @TableName = v.Parameter1,
                   @ColumnName = v.Parameter2,
                   @Parameter3 = v.Parameter3,
                   @Parameter4 = v.Parameter4
            FROM Versionen v
            WHERE VersionNummer = @currentVersion;

            PRINT('Rolling back: ' + @procedureName);

            IF (@procedureName = 'CreateTableVersioned')
                EXEC RollbackCreateTable @TableName;
            ELSE IF (@procedureName = 'AddForeignKeyConstraintVersioned')
                EXEC RollbackAddForeignKeyConstraint @TableName, @ColumnName;
            ELSE IF (@procedureName = 'AddColumnToTableVersioned')
                EXEC RollbackAddColumnToTable @TableName, @ColumnName;
            ELSE IF (@procedureName = 'AddDefaultConstraintVersioned')
                EXEC RollbackAddDefaultConstraint @TableName, @ColumnName;
			ELSE IF (@procedureName = 'ModifyColumnTypeVersioned')
                SELECT @Parameter4 = v.Parameter4
                FROM Versionen v
                WHERE VersionNummer = @currentVersion;

                EXEC RollbackModifyColumnType @TableName, @ColumnName, @Parameter4;

            SET @currentVersion = @currentVersion - 1;

            UPDATE Version SET currentVersion = @currentVersion;
        END

        COMMIT;
    END
    ELSE
    BEGIN
        BEGIN TRANSACTION;

        SET @currentVersion = @currentVersion + 1;

        WHILE @currentVersion < @changedVersion + 1
        BEGIN
            SELECT @procedureName = v.Prozedur,
                   @TableName = v.Parameter1,
                   @ColumnName = v.Parameter2,
                   @Parameter3 = v.Parameter3,
                   @Parameter4 = v.Parameter4
            FROM Versionen v
            WHERE v.VersionNummer = @currentVersion;

            PRINT('Applying: ' + @procedureName);

            IF (@procedureName = 'CreateTableVersioned')
                EXEC CreateTable @TableName, @ColumnName;
            ELSE IF (@procedureName = 'AddForeignKeyConstraintVersioned')
                EXEC AddForeignKeyConstraint @TableName, @ColumnName, @Parameter3, @Parameter4;
            ELSE IF (@procedureName = 'AddColumnToTableVersioned')
                EXEC AddColumnToTable @TableName, @ColumnName, @Parameter3;
            ELSE IF (@procedureName = 'AddDefaultConstraintVersioned')
                EXEC AddDefaultConstraint @TableName, @ColumnName, @Parameter3;
            ELSE IF (@procedureName = 'ModifyColumnTypeVersioned')
                EXEC ModifyColumnType @TableName, @ColumnName, @Parameter3;

            SET @currentVersion = @currentVersion + 1;

            UPDATE Version SET currentVersion = @currentVersion;
        END

        COMMIT;
    END;
END;

CREATE OR ALTER PROCEDURE CreateTableVersioned
    @TableName VARCHAR(50),
    @ColumnsDefinition VARCHAR(MAX)
AS 
BEGIN
    DECLARE @version AS INT
    SET @version = (SELECT ISNULL(MAX(VersionNummer), 0) FROM Versionen) + 1

    INSERT INTO Versionen (VersionNummer, Prozedur, Parameter1, Parameter2)
    VALUES (@version, 'CreateTableVersioned', @TableName, @ColumnsDefinition)

    UPDATE Version
    SET currentVersion = @version

    PRINT('CREATE TABLE ' + @TableName + ' (' + @ColumnsDefinition + ')')
    DECLARE @query AS VARCHAR(MAX) = 'CREATE TABLE ' + @TableName + ' (' + @ColumnsDefinition + ')'
    EXEC(@query)
END
GO


CREATE OR ALTER PROCEDURE AddForeignKeyConstraintVersioned
    @TableName VARCHAR(50),
    @ColumnName VARCHAR(50),
    @ReferencedTable VARCHAR(50),
    @ReferencedColumn VARCHAR(50)
AS
BEGIN
DECLARE @version AS int
SET @version= (SELECT currentVersion FROM Version)+1
INSERT INTO Versionen(VersionNummer, Prozedur, Parameter1, Parameter2, Parameter3, Parameter4) VALUES (@version, 'AddForeignKeyConstraintVersioned', @TableName , @ColumnName , @ReferencedTable , @ReferencedColumn )

UPDATE Version
SET currentVersion=currentVersion+1
DECLARE @query AS VARCHAR(MAX) = 'ALTER TABLE ' + @TableName + ' ADD CONSTRAINT FK_' + @TableName + '_' + @ColumnName +
               ' FOREIGN KEY (' + @ColumnName + ') REFERENCES ' + @ReferencedTable + '(' + @ReferencedColumn + ')'
print(@query)
EXEC(@query)
END
GO

CREATE OR ALTER PROCEDURE AddColumnToTableVersioned
    @TableName VARCHAR(50),
    @ColumnName VARCHAR(50),
    @DataType VARCHAR(50)
AS
BEGIN
DECLARE @version AS int
SET @version= (SELECT currentVersion FROM Version)+1
INSERT INTO Versionen(VersionNummer, Prozedur, Parameter1, Parameter2, Parameter3) VALUES (@version, 'AddColumnToTableVersioned', @TableName, @ColumnName, @DataType)

UPDATE Version
SET currentVersion=currentVersion+1
DECLARE @query AS VARCHAR(MAX) = 'ALTER TABLE ' + @TableName + ' ADD ' + @ColumnName + ' ' + @DataType
EXEC(@query)
END
GO


CREATE OR ALTER PROCEDURE AddDefaultConstraintVersioned
    @TableName VARCHAR(50),
    @ColumnName VARCHAR(50),
    @DefaultValue VARCHAR(50)
AS
BEGIN
DECLARE @version AS int
SET @version= (SELECT currentVersion FROM Version)+1
INSERT INTO Versionen(VersionNummer, Prozedur, Parameter1, Parameter2, Parameter3) VALUES (@version, 'AddDefaultConstraintVersioned', @TableName, @ColumnName, @DefaultValue)

UPDATE Version
SET currentVersion=currentVersion+1
DECLARE @checkedDefaultValue varchar(100)
IF ISNUMERIC(@defaultValue) = 1
SET @checkedDefaultValue = @defaultValue
ELSE
SET @checkedDefaultValue = '''' + @defaultValue + ''''
DECLARE @query AS VARCHAR(MAX) =  'ALTER TABLE ' + @TableName + ' ADD CONSTRAINT DF_' + @TableName + '_' + @ColumnName + ' DEFAULT ' + @DefaultValue + ' FOR ' + @ColumnName
EXEC(@query)
END
GO


CREATE OR ALTER PROCEDURE ModifyColumnTypeVersioned
    @TableName VARCHAR(50),
    @ColumnName VARCHAR(50),
    @NewDataType VARCHAR(50)AS
BEGIN
DECLARE @version AS int
SET @version= (SELECT currentVersion FROM Version)+1

DECLARE @size AS int
SET @size = (SELECT CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=@TableName AND COLUMN_NAME=@ColumnName)
DECLARE @initialType AS VARCHAR(MAX)
SET @initialType= (SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=@TableName AND COLUMN_NAME=@ColumnName)

if @size is not null
begin
SET @initialType= @initialType + '(' + cast(@size as varchar(max)) + ')' 
end
INSERT INTO Versionen(VersionNummer, Prozedur, Parameter1, Parameter2, Parameter3, Parameter4) VALUES (@version, 'modifyColumnType', @TableName, @ColumnName, @NewDataType, @initialType)

UPDATE Version
SET currentVersion=currentVersion+1
DECLARE @query AS VARCHAR(MAX) = 'alter table ' + @TableName + ' ' + 'alter column ' + @ColumnName + ' ' + @NewDataType
EXEC(@query)
END
GO

CREATE OR ALTER PROCEDURE RollbackModifyColumnType
    @TableName VARCHAR(50),
    @ColumnName VARCHAR(50),
    @OldDataType VARCHAR(50)
AS
BEGIN
    DECLARE @query AS VARCHAR(MAX) = 'alter table ' + @TableName + ' ' + 'alter column ' + @ColumnName + ' ' + @OldDataType
    EXEC(@query)
END;




DELETE FROM Versionen
GO

UPDATE Version
SET currentVersion=0;

SELECT * FROM Versionen
SELECT * FROM VERSION

EXEC CreateTableVersioned @TableName = 'Eltern_Kinder' , @ColumnsDefinition = 'ID_Eltern INT PRIMARY KEY'
GO

SELECT * FROM Versionen
SELECT * FROM VERSION

EXEC AddColumnToTableVersioned @TableName='Eltern_Kinder' , @ColumnName='Age', @DataType='INT'
GO

SELECT * FROM Versionen
SELECT * FROM VERSION

EXEC AddColumnToTableVersioned @TableName='Eltern_Kinder' , @ColumnName='Name', @DataType='VARCHAR(50)'
GO

SELECT * FROM Versionen
SELECT * FROM VERSION

EXEC ModifyColumnTypeVersioned @TableName='Eltern_Kinder', @ColumnName='Name', @NewDataType='CHAR(20)'
GO

SELECT * FROM Versionen
SELECT * FROM VERSION

EXEC AddDefaultConstraintVersioned @TableName='Eltern_Kinder', @ColumnName='Age', @DefaultValue='35'
GO

SELECT * FROM Versionen
SELECT * FROM VERSION

EXEC AddDefaultConstraintVersioned @TableName='Eltern_Kinder', @ColumnName='Name', @DefaultValue='''Maria'''
GO

SELECT * FROM Versionen
SELECT * FROM VERSION

EXEC CreateTableVersioned @TableName = 'Kinder' , @ColumnsDefinition = 'ID_Kind INT PRIMARY KEY, Name VARCHAR(50)'
GO

SELECT * FROM Versionen
SELECT * FROM VERSION

EXEC AddColumnToTableVersioned @TableName='Kinder' , @ColumnName='ID_Eltern', @DataType='INT'
GO

SELECT * FROM Versionen
SELECT * FROM VERSION

EXEC AddForeignKeyConstraintVersioned @TableName='Kinder', @ColumnName='ID_Eltern', @ReferencedTable='Eltern_Kinder', @ReferencedColumn='ID_Eltern'
GO

SELECT * FROM Versionen
SELECT * FROM VERSION



EXEC GoToVersion @changedversion=3
GO

SELECT * FROM VERSION

EXEC GoToVersion @changedversion=9
GO

SELECT * FROM VERSION

EXEC GoToVersion @changedversion=8
GO

SELECT * FROM VERSION



DROP TABLE Eltern_Kinder
GO

DROP TABLE Kinder
GO


DELETE FROM Versionen
GO

SELECT * FROM Versionen
SELECT * FROM VERSION


UPDATE Version
SET currentVersion=0;

SELECT * FROM Versionen
SELECT * FROM VERSION

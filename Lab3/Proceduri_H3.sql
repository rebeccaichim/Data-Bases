--DROP PROCEDURE IF EXISTS CreateTable;
CREATE PROCEDURE CreateTable
    @TableName VARCHAR(50),
    @ColumnsDefinition VARCHAR(MAX)
AS
BEGIN
    DECLARE @SQL VARCHAR(MAX);
    SET @SQL = 'CREATE TABLE ' + @TableName + ' (' + @ColumnsDefinition + ')';
    EXEC(@SQL);
END;

EXEC CreateTable 'Eltern', 'ID_Eltern INT PRIMARY KEY, Name VARCHAR(50), Age INT';
EXEC CreateTable 'Reservierung', 'Reservierung_ID INT PRIMARY KEY, Name VARCHAR(50), Datum DATE';



--DROP PROCEDURE IF EXISTS RollbackCreateTable;
CREATE PROCEDURE RollbackCreateTable
    @TableName VARCHAR(50)
AS
BEGIN
    DECLARE @SQL VARCHAR(MAX);
    SET @SQL = 'DROP TABLE ' + @TableName;
    EXEC(@SQL);
END;

EXEC RollbackCreateTable 'Eltern';
EXEC RollbackCreateTable 'Reservierung';



--DROP PROCEDURE IF EXISTS AddForeignKeyConstraint;
CREATE PROCEDURE AddForeignKeyConstraint
    @TableName VARCHAR(50),
    @ColumnName VARCHAR(50),
    @ReferencedTable VARCHAR(50),
    @ReferencedColumn VARCHAR(50)
AS
BEGIN
    DECLARE @SQL VARCHAR(MAX);
    SET @SQL = 'ALTER TABLE ' + @TableName + ' ADD CONSTRAINT FK_' + @TableName + '_' + @ColumnName +
               ' FOREIGN KEY (' + @ColumnName + ') REFERENCES ' + @ReferencedTable + '(' + @ReferencedColumn + ')';
    EXEC(@SQL);
END;

EXEC CreateTable 'Eltern_Kinder', 'ID_Eltern INT PRIMARY KEY, Name VARCHAR(50), Age INT';
EXEC CreateTable 'Kinder', 'ID_Kind INT PRIMARY KEY, Name VARCHAR(50), ID_Eltern INT';
EXEC AddForeignKeyConstraint 'Kinder', 'ID_Eltern', 'Eltern_Kinder', 'ID_Eltern';



--DROP PROCEDURE IF EXISTS RollbackAddForeignKeyConstraint;
CREATE PROCEDURE RollbackAddForeignKeyConstraint
    @TableName VARCHAR(50),
    @ColumnName VARCHAR(50)

AS
BEGIN
    DECLARE @sql VARCHAR(MAX);
    SET @sql = 'ALTER TABLE ' + @TableName + ' DROP CONSTRAINT FK_' + @TableName + '_' + @ColumnName;
    EXEC (@sql);
END

EXEC RollbackAddForeignKeyConstraint 'Kinder', 'ID_Eltern' ;

EXEC RollbackCreateTable 'Kinder';
EXEC RollbackCreateTable 'Eltern_Kinder';



--DROP PROCEDURE IF EXISTS AddColumnToTable;
CREATE PROCEDURE AddColumnToTable
    @TableName VARCHAR(50),
    @ColumnName VARCHAR(50),
    @DataType VARCHAR(50)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    SET @SQL = 'ALTER TABLE ' + @TableName + ' ADD ' + @ColumnName + ' ' + @DataType;
    EXEC(@SQL);
END;

EXEC CreateTable 'Eltern_Kinder', 'ID_Eltern INT PRIMARY KEY, Name VARCHAR(50)';
EXEC AddColumnToTable 'Eltern_Kinder', 'Age', 'INT';


--DROP PROCEDURE IF EXISTS RollbackAddColumnToTable;
CREATE PROCEDURE RollbackAddColumnToTable
    @TableName VARCHAR(50),
    @ColumnName VARCHAR(50)
AS
BEGIN
    DECLARE @SQL VARCHAR(MAX);
    SET @SQL = 'ALTER TABLE ' + @TableName + ' DROP COLUMN ' + @ColumnName;
    EXEC(@SQL);
END;

EXEC RollbackAddColumnToTable 'Eltern_Kinder', 'Age';
EXEC RollbackCreateTable 'Eltern_Kinder';


--DROP PROCEDURE IF EXISTS AddDefaultConstraint;
CREATE PROCEDURE AddDefaultConstraint
    @TableName VARCHAR(50),
    @ColumnName VARCHAR(50),
    @DefaultValue VARCHAR(50)
AS
BEGIN
    DECLARE @SQL VARCHAR(MAX);
    SET @SQL = 'ALTER TABLE ' + @TableName + ' ADD CONSTRAINT DF_' + @TableName + '_' + @ColumnName + ' DEFAULT ' + @DefaultValue + ' FOR ' + @ColumnName;
    EXEC(@SQL);
END;

EXEC CreateTable 'Eltern_Kinder', 'ID_Eltern INT PRIMARY KEY, Name VARCHAR(50), Age INT';
EXEC AddDefaultConstraint 'Eltern_Kinder', 'Age', '35';
EXEC AddDefaultConstraint 'Eltern_Kinder', 'Name ', '''Maria''';

--INSERT INTO Eltern_Kinder (ID_Eltern) VALUES (2);



--DROP PROCEDURE IF EXISTS RollbackAddDefaultConstraint;
CREATE PROCEDURE RollbackAddDefaultConstraint
    @TableName VARCHAR(50),
    @ColumnName VARCHAR(50)
AS
BEGIN
    DECLARE @SQL VARCHAR(MAX);
    SET @SQL = 'ALTER TABLE ' + @TableName + ' DROP CONSTRAINT DF_' + @TableName + '_' + @ColumnName;
    EXEC(@SQL);
END;

EXEC RollbackAddDefaultConstraint 'Eltern_Kinder', 'Age';
EXEC RollbackAddDefaultConstraint 'Eltern_Kinder', 'Name';
EXEC RollbackCreateTable 'Eltern_Kinder';

--DROP PROCEDURE IF EXISTS RollbackModifyColumnType;
CREATE PROCEDURE ModifyColumnType
    @TableName VARCHAR(50),
    @ColumnName VARCHAR(50),
    @NewDataType VARCHAR(50)
AS
BEGIN
    DECLARE @SQL VARCHAR(MAX);
    SET @SQL = 'ALTER TABLE ' + @TableName + ' ALTER COLUMN ' + @ColumnName + ' ' + @NewDataType;
    EXEC(@SQL);
END;




--CreateTable
EXEC CreateTable 'Eltern_Kinder', 'ID_Eltern INT PRIMARY KEY, Name VARCHAR(50)';
EXEC CreateTable 'Reservierung', 'Reservierung_ID INT PRIMARY KEY, Name VARCHAR(50), Datum DATE';
--RollbackCreateTable
EXEC RollbackCreateTable 'Eltern';
EXEC RollbackCreateTable 'Reservierung';
--AddForeignKeyConstraint
EXEC CreateTable 'Eltern_Kinder', 'ID_Eltern INT PRIMARY KEY, Name VARCHAR(50), Age INT';
EXEC CreateTable 'Kinder', 'ID_Kind INT PRIMARY KEY, Name VARCHAR(50), ID_Eltern INT';
EXEC AddForeignKeyConstraint 'Kinder', 'ID_Eltern', 'Eltern_Kinder', 'ID_Eltern';
--RollbackAddForeignKeyConstraint
EXEC RollbackCreateTable 'Kinder';
EXEC RollbackCreateTable 'Eltern_Kinder';
--AddColumnToTable
EXEC CreateTable 'Eltern_Kinder', 'ID_Eltern INT PRIMARY KEY, Name VARCHAR(50)';
EXEC AddColumnToTable 'Eltern_Kinder', 'Age', 'INT';
--RollbackAddColumnToTable
EXEC RollbackAddColumnToTable 'Eltern_Kinder', 'Age';
EXEC RollbackCreateTable 'Eltern_Kinder';
--AddDefaultConstraint
EXEC CreateTable 'Eltern_Kinder', 'ID_Eltern INT PRIMARY KEY, Name VARCHAR(50), Age INT';
EXEC AddDefaultConstraint 'Eltern_Kinder', 'Age', '35';
EXEC AddDefaultConstraint 'Eltern_Kinder', 'Name ', '''Maria''';
--INSERT INTO Eltern_Kinder (ID_Eltern) VALUES (1);
--RollbackAddDefaultConstraint
EXEC RollbackAddDefaultConstraint 'Eltern_Kinder', 'Age';
EXEC RollbackAddDefaultConstraint 'Eltern_Kinder', 'Name';
EXEC RollbackCreateTable 'Eltern_Kinder';
--ModifyColumnType
EXEC CreateTable 'Eltern_Kinder', 'ID_Eltern INT PRIMARY KEY, Name VARCHAR(50), Age INT';
EXEC ModifyColumnType 'Eltern_Kinder', 'Age', 'VARCHAR(50)';


EXEC CreateTable 'Eltern_Kinder', 'ID_Eltern INT PRIMARY KEY, Name VARCHAR(50)';
EXEC AddColumnToTable 'Eltern_Kinder', 'Age', 'INT';
EXEC ModifyColumnType 'Eltern_Kinder', 'Age', 'VARCHAR(50)';
EXEC CreateTable 'Kinder', 'ID_Kind INT PRIMARY KEY, Name VARCHAR(50), ID_Eltern INT';
EXEC AddForeignKeyConstraint 'Kinder', 'ID_Eltern', 'Eltern_Kinder', 'ID_Eltern';
EXEC AddDefaultConstraint 'Eltern_Kinder', 'Age', '35';
EXEC AddDefaultConstraint 'Eltern_Kinder', 'Name ', '''Maria''';










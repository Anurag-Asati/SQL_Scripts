CREATE PROCEDURE [dbo].[UpdateGroupPermissions]
    @xmlPermissions TEXT,
    @xmlDocumentClassificationRights TEXT
AS
BEGIN
    SET NOCOUNT ON;

    -- Process tblPermissions
    -- SQL Server handles XML parsing with the .nodes() and .value() methods directly on the XML type.
    -- We'll use a MERGE statement for an "UPSERT" (Update or Insert) pattern.

    MERGE INTO [dbo].[GroupPermits] AS target
    USING (
        SELECT
            T.c.value('@SecurityGroup[1]', 'UNIQUEIDENTIFIER') AS SecurityGroup,
            T.c.value('@PermissionKey[1]', 'NVARCHAR(50)') AS PermissionKey,
            T.c.value('@Actions[1]', 'INT') AS Actions
        FROM (SELECT CAST(@xmlPermissions AS XML) AS xmlData) AS a
        CROSS APPLY a.xmlData.nodes('/NewDataSet/tblPermissions') AS T(c)
        WHERE T.c.value('@SecurityGroup[1]', 'UNIQUEIDENTIFIER') IS NOT NULL
    ) AS source (SecurityGroup, PermissionKey, Actions)
    ON (target.PermissionKey = source.PermissionKey AND target.SecurityGroup = source.SecurityGroup)
    WHEN MATCHED THEN
        UPDATE SET target.Actions = source.Actions
    WHEN NOT MATCHED BY TARGET THEN
        INSERT ([Id], [SecurityGroup], [PermissionKey], [Actions])
        VALUES (NEWID(), source.SecurityGroup, source.PermissionKey, source.Actions);


    -- Process tblDocumentClassificationRights
    MERGE INTO [dbo].[GroupClasses] AS target
    USING (
        SELECT
            T.c.value('@Classification[1]', 'UNIQUEIDENTIFIER') AS Classification,
            T.c.value('@SecurityGroup[1]', 'UNIQUEIDENTIFIER') AS SecurityGroup,
            T.c.value('@CanRead[1]', 'BIT') AS CanRead,
            T.c.value('@CanDelete[1]', 'BIT') AS CanDelete,
            T.c.value('@CanIndex[1]', 'BIT') AS CanIndex,
            T.c.value('@CanMap[1]', 'BIT') AS CanMap,
            T.c.value('@CanAddNotes[1]', 'BIT') AS CanAddNotes
        FROM (SELECT CAST(@xmlDocumentClassificationRights AS XML) AS xmlData) AS a
        CROSS APPLY a.xmlData.nodes('//tblClassificationRights') AS T(c)
        WHERE T.c.value('@SecurityGroup[1]', 'UNIQUEIDENTIFIER') IS NOT NULL
    ) AS source (Classification, SecurityGroup, CanRead, CanDelete, CanIndex, CanMap, CanAddNotes)
    ON (target.ClassificationId = source.Classification AND target.SecurityGroupId = source.SecurityGroup)
    WHEN MATCHED THEN
        UPDATE SET
            target.CanRead = source.CanRead,
            target.CanDelete = source.CanDelete,
            target.CanIndex = source.CanIndex,
            target.CanMap = source.CanMap,
            target.CanAddNotes = source.CanAddNotes
    WHEN NOT MATCHED BY TARGET THEN
        INSERT ([Id], [ClassificationId], [SecurityGroupId], [CanRead], [CanDelete], [CanIndex], [CanMap], [CanAddNotes])
        VALUES (NEWID(), source.Classification, source.SecurityGroup, source.CanRead, source.CanDelete, source.CanIndex, source.CanMap, source.CanAddNotes);

END;
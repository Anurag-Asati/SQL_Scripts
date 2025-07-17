CREATE TABLE [dbo].[GroupPermits] (
    [Id]            UNIQUEIDENTIFIER NOT NULL,
    [SecurityGroup] UNIQUEIDENTIFIER NOT NULL,
    [PermissionKey] NVARCHAR (50)    NOT NULL,
    [Actions]       INT              NOT NULL,
    CONSTRAINT [PK_GroupPermits] PRIMARY KEY CLUSTERED ([Id] ASC)
);
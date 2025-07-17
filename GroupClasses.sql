CREATE TABLE [dbo].[GroupClasses] (
    [Id]                UNIQUEIDENTIFIER NOT NULL,
    [ClassificationId]  UNIQUEIDENTIFIER NOT NULL,
    [SecurityGroupId]   UNIQUEIDENTIFIER NOT NULL,
    [CanRead]           BIT              NOT NULL,
    [CanDelete]         BIT              NOT NULL,
    [CanAddNotes]       BIT              NOT NULL,
    [CanIndex]          BIT              NOT NULL,
    [CanMap]            BIT              NOT NULL,
    CONSTRAINT [PK_GroupClasses] PRIMARY KEY CLUSTERED ([Id] ASC)
);
BEGIN TRANSACTION;
DROP TABLE IF EXISTS `tracks`;
CREATE TABLE IF NOT EXISTS `tracks` (
	`TrackId`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`Name`	NVARCHAR(200) NOT NULL,
	`AlbumId`	INTEGER,
	`MediaTypeId`	INTEGER NOT NULL,
	`GenreId`	INTEGER,
	`Composer`	NVARCHAR(220),
	`Milliseconds`	INTEGER NOT NULL,
	`Bytes`	INTEGER,
	`UnitPrice`	NUMERIC(10 , 2) NOT NULL,
	FOREIGN KEY(`AlbumId`) REFERENCES `albums`(`AlbumId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	FOREIGN KEY(`GenreId`) REFERENCES `genres`(`GenreId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	FOREIGN KEY(`MediaTypeId`) REFERENCES `media_types`(`MediaTypeId`) ON DELETE NO ACTION ON UPDATE NO ACTION
);
DROP TABLE IF EXISTS `playlist_track`;
CREATE TABLE IF NOT EXISTS `playlist_track` (
	`PlaylistId`	INTEGER NOT NULL,
	`TrackId`	INTEGER NOT NULL,
	CONSTRAINT `PK_PlaylistTrack` PRIMARY KEY(`PlaylistId`,`TrackId`),
	FOREIGN KEY(`PlaylistId`) REFERENCES `playlists`(`PlaylistId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	FOREIGN KEY(`TrackId`) REFERENCES `tracks`(`TrackId`) ON DELETE NO ACTION ON UPDATE NO ACTION
);
DROP TABLE IF EXISTS `playlists`;
CREATE TABLE IF NOT EXISTS `playlists` (
	`PlaylistId`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`Name`	NVARCHAR(120)
);
DROP TABLE IF EXISTS `media_types`;
CREATE TABLE IF NOT EXISTS `media_types` (
	`MediaTypeId`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`Name`	NVARCHAR(120)
);
DROP TABLE IF EXISTS `invoice_items`;
CREATE TABLE IF NOT EXISTS `invoice_items` (
	`InvoiceLineId`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`InvoiceId`	INTEGER NOT NULL,
	`TrackId`	INTEGER NOT NULL,
	`UnitPrice`	NUMERIC(10 , 2) NOT NULL,
	`Quantity`	INTEGER NOT NULL,
	FOREIGN KEY(`InvoiceId`) REFERENCES `invoices`(`InvoiceId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
	FOREIGN KEY(`TrackId`) REFERENCES `tracks`(`TrackId`) ON DELETE NO ACTION ON UPDATE NO ACTION
);
DROP TABLE IF EXISTS `invoices`;
CREATE TABLE IF NOT EXISTS `invoices` (
	`InvoiceId`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`CustomerId`	INTEGER NOT NULL,
	`InvoiceDate`	DATETIME NOT NULL,
	`BillingAddress`	NVARCHAR(70),
	`BillingCity`	NVARCHAR(40),
	`BillingState`	NVARCHAR(40),
	`BillingCountry`	NVARCHAR(40),
	`BillingPostalCode`	NVARCHAR(10),
	`Total`	NUMERIC(10 , 2) NOT NULL,
	FOREIGN KEY(`CustomerId`) REFERENCES `customers`(`CustomerId`) ON DELETE NO ACTION ON UPDATE NO ACTION
);
DROP TABLE IF EXISTS `genres`;
CREATE TABLE IF NOT EXISTS `genres` (
	`GenreId`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`Name`	NVARCHAR(120)
);
DROP TABLE IF EXISTS `employees`;
CREATE TABLE IF NOT EXISTS `employees` (
	`EmployeeId`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`LastName`	NVARCHAR(20) NOT NULL,
	`FirstName`	NVARCHAR(20) NOT NULL,
	`Title`	NVARCHAR(30),
	`ReportsTo`	INTEGER,
	`BirthDate`	DATETIME,
	`HireDate`	DATETIME,
	`Address`	NVARCHAR(70),
	`City`	NVARCHAR(40),
	`State`	NVARCHAR(40),
	`Country`	NVARCHAR(40),
	`PostalCode`	NVARCHAR(10),
	`Phone`	NVARCHAR(24),
	`Fax`	NVARCHAR(24),
	`Email`	NVARCHAR(60),
	FOREIGN KEY(`ReportsTo`) REFERENCES `employees`(`EmployeeId`) ON DELETE NO ACTION ON UPDATE NO ACTION
);
DROP TABLE IF EXISTS `customers`;
CREATE TABLE IF NOT EXISTS `customers` (
	`CustomerId`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`FirstName`	NVARCHAR(40) NOT NULL,
	`LastName`	NVARCHAR(20) NOT NULL,
	`Company`	NVARCHAR(80),
	`Address`	NVARCHAR(70),
	`City`	NVARCHAR(40),
	`State`	NVARCHAR(40),
	`Country`	NVARCHAR(40),
	`PostalCode`	NVARCHAR(10),
	`Phone`	NVARCHAR(24),
	`Fax`	NVARCHAR(24),
	`Email`	NVARCHAR(60) NOT NULL,
	`SupportRepId`	INTEGER,
	FOREIGN KEY(`SupportRepId`) REFERENCES `employees`(`EmployeeId`) ON DELETE NO ACTION ON UPDATE NO ACTION
);
DROP TABLE IF EXISTS `artists`;
CREATE TABLE IF NOT EXISTS `artists` (
	`ArtistId`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`Name`	NVARCHAR(120)
);
DROP TABLE IF EXISTS `albums`;
CREATE TABLE IF NOT EXISTS `albums` (
	`AlbumId`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`Title`	NVARCHAR(160) NOT NULL,
	`ArtistId`	INTEGER NOT NULL,
	FOREIGN KEY(`ArtistId`) REFERENCES `artists`(`ArtistId`) ON DELETE NO ACTION ON UPDATE NO ACTION
);
DROP INDEX IF EXISTS `IFK_TrackMediaTypeId`;
CREATE INDEX IF NOT EXISTS `IFK_TrackMediaTypeId` ON `tracks` (
	`MediaTypeId`
);
DROP INDEX IF EXISTS `IFK_TrackGenreId`;
CREATE INDEX IF NOT EXISTS `IFK_TrackGenreId` ON `tracks` (
	`GenreId`
);
DROP INDEX IF EXISTS `IFK_TrackAlbumId`;
CREATE INDEX IF NOT EXISTS `IFK_TrackAlbumId` ON `tracks` (
	`AlbumId`
);
DROP INDEX IF EXISTS `IFK_PlaylistTrackTrackId`;
CREATE INDEX IF NOT EXISTS `IFK_PlaylistTrackTrackId` ON `playlist_track` (
	`TrackId`
);
DROP INDEX IF EXISTS `IFK_InvoiceLineTrackId`;
CREATE INDEX IF NOT EXISTS `IFK_InvoiceLineTrackId` ON `invoice_items` (
	`TrackId`
);
DROP INDEX IF EXISTS `IFK_InvoiceLineInvoiceId`;
CREATE INDEX IF NOT EXISTS `IFK_InvoiceLineInvoiceId` ON `invoice_items` (
	`InvoiceId`
);
DROP INDEX IF EXISTS `IFK_InvoiceCustomerId`;
CREATE INDEX IF NOT EXISTS `IFK_InvoiceCustomerId` ON `invoices` (
	`CustomerId`
);
DROP INDEX IF EXISTS `IFK_EmployeeReportsTo`;
CREATE INDEX IF NOT EXISTS `IFK_EmployeeReportsTo` ON `employees` (
	`ReportsTo`
);
DROP INDEX IF EXISTS `IFK_CustomerSupportRepId`;
CREATE INDEX IF NOT EXISTS `IFK_CustomerSupportRepId` ON `customers` (
	`SupportRepId`
);
DROP INDEX IF EXISTS `IFK_AlbumArtistId`;
CREATE INDEX IF NOT EXISTS `IFK_AlbumArtistId` ON `albums` (
	`ArtistId`
);
COMMIT;

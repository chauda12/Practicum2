Create Table title (
	titleID varchar(40),
    titleType longtext,
    primaryTitle longtext,
    originalTitle longtext,
    isAdult bool,
    startYear int,
    endYear int,
    runtimeMinutes int,
    Constraint PK_titleID Primary Key (titleID)
);

Create Table genres (
	genreID int AUTO_INCREMENT,
	genreText varchar(40),
    Constraint PK_genreID Primary Key (genreID)
);

Create Table titleGenre (
	titleGenreID int AUTO_INCREMENT,
    titleID varchar(40),
    genreID int,
    Constraint PK_titleGenreID Primary Key (titleGenreID),
    Constraint FK_titleID_tg Foreign Key (titleID) References title(titleID),
	Constraint FK_genreID_tg Foreign Key (genreID) References genres(genreID)
);

Create Table episode (
	episodeID int AUTO_INCREMENT,
    titleID varchar(40),
    seasonNumber int,
    episodeNumber int,
    Constraint PK_episodeID Primary Key (episodeID),
    Constraint FK_titleID_e Foreign Key (titleID) References title(titleID)
);

Create Table rating (
	ratingID int AUTO_INCREMENT,
    titleID varchar(40),
    averageRating int,
    numVotes int,
    Constraint PK_ratingID Primary Key (ratingID),
    Constraint FK_titleID_r Foreign Key (titleID) References title(titleID)
);

/* akas */
Create Table titleInfo (
	titleInfoID int AUTO_INCREMENT,
	titleID varchar(40),
    ordering int,
    title longtext,
    region varchar(40),
    language varchar(40),
    isOriginalTitle bool,
    Constraint PK_titleInfoID Primary Key (titleInfoID),
    Constraint FK_titleID_t Foreign Key (titleID) REFERENCES title(titleID)
);

Create Table titleInfo (
	titleInfoID int AUTO_INCREMENT,
    titleID varchar(40),
    ordering int,
    title longtext,
    region longtext,
    language longtext,
    isOriginal boolean,
    Constraint PK_titleInfoID Primary Key (titleInfoID),
    Constraint FK_titleID_ti Foreign Key (titleID) References title(titleID)
);

Create Table mediaType (
	mediaTypeID int AUTO_INCREMENT,
    mediaTypeText longtext,
    Constraint PK_mediaTypeID Primary Key (mediaTypeID)
);

Create Table titleMediaType (
	titleMediaTypeID int AUTO_INCREMENT,
    titleInfoID int,
    mediaTypeID int,
    Constraint PK_titleInfoTypeID Primary Key (titleMediaTypeID),
    Constraint FK_titleInfoID_tit Foreign Key (titleInfoID) References titleInfo(titleInfoID),
	Constraint FK_mediaTypeID_tit Foreign Key (mediaTypeID) References mediaType(mediaTypeID)
);

Create Table attribute (
	attributeID int AUTO_INCREMENT,
    attributeText longtext,
    Constraint PK_attributeID Primary Key (attributeID)
);

Create Table titleAttribute (
	titleAttributeID int AUTO_INCREMENT,
    titleInfoID int,
    attributeID int,
    Constraint PK_titleAttributeID Primary Key (titleAttributeID),
    Constraint FK_titleInfoID_ta Foreign Key (titleInfoID) References titleInfo(titleInfoID),
	Constraint FK_attributeID_ta Foreign Key (attributeID) References attribute(attributeID)
);

Create Table person (
	personID varchar(40),
    primaryName longtext,
    birthYear int,
    deathYear int,
    Constraint PK_personID Primary Key (personID)
);

Create Table profession (
	professionID int AUTO_INCREMENT,
    professionText longtext,
    Constraint PK_professionID Primary Key (professionID)
);

Create Table personProfession (
	personProfessionID int AUTO_INCREMENT,
	personID varchar(40),
    professionID int,
    Constraint PK_personProfessionID Primary Key (personProfessionID),
    Constraint FK_personID_pp Foreign Key (personID) References person(personID),
	Constraint FK_professionID_pp Foreign Key (professionID) References profession(professionID)
);

Create Table knownFor (
	knownForID int AUTO_INCREMENT,
    personID varchar(40),
    titleID varchar(40),
    Constraint PK_knownForID Primary Key (knownForID),
    Constraint FK_personID_kf Foreign Key (personID) References person(personID),
	Constraint FK_titleID_kf Foreign Key (titleID) References title(titleID)
);

Create Table crew (
	crewID int AUTO_INCREMENT,
    personID varchar(40),
    titleID varchar(40),
    job boolean,
	Constraint PK_crewID Primary Key (crewID),
    Constraint FK_personID_c Foreign Key (personID) References person(personID),
	Constraint FK_titleID_c Foreign Key (titleID) References title(titleID)
);

Create Table principals (
	principalID int AUTO_INCREMENT,
    titleID varchar(40),
    ordering int,
    personID varchar(40),
    category longtext,
    job longtext,
    characters longtext,
    Constraint PK_principalID Primary Key (principalID),
	Constraint FK_titleID_p Foreign Key (titleID) References title(titleID),
	Constraint FK_personID_p Foreign Key (personID) References person(personID)
);

Create Table genrehelper (
	tconst varchar(40),
    genre1 varchar(40),
    genre2 varchar(40),
    genre3 varchar(40)
);



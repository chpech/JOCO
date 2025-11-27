#############################################################################
##
##  PackageInfo.g for the package `JOCO'                       Mikhail Klin
##                                                             Christian Pech
##  (created from Frank Lübeck's PackageInfo.g template file)
##

SetPackageInfo( rec(
PackageName := "JOCO",
Subtitle := "Computations in Jordan Configurations",
Version := "0.1",
Date := "27/11/2025",
License := "GPL-3.0",
Persons := [
  rec(
    LastName      := "Klin",
    FirstNames    := "Mikhail",
    IsAuthor      := true,
    IsMaintainer  := false,
    Email         := "klinm@bgu.ac.il",
  ),
  rec(
    LastName      := "Pech",
    FirstNames    := "Christian",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "cpech@freenet.de",
  )
],

Status := "dev",

SourceRepository := rec(
    Type := "git",
    URL := "https://github.com/chpech/JOCO",
),
IssueTrackerURL := "https://github.com/chpech/JOCO/issues",
PackageWWWHome := "https://github.com/chpech/joco/",
README_URL := Concatenation( ~.PackageWWWHome, "blob/master/README" ),
PackageInfoURL := Concatenation( ~.PackageWWWHome, "blob/master/PackageInfo.g" ),
ArchiveURL := Concatenation( ~.PackageWWWHome, "archive/", "joco-", ~.Version ),
ArchiveFormats := ".tar.gz",

AbstractHTML := "The <span class=\"pkgname\">JOCO</span> package provides\
          functionality for computing in Jordan configurations and Rainbows;",

PackageDoc := rec(
  BookName  := ~.PackageName,
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0_mj.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := ~.Subtitle,
),

AutoDoc := rec(
    entities := rec(
        VERSION := ~.Version,
        DATE   := ~.Date,
        COCO   := "<Package>coco2p</Package>",
	JOCO   := "<Package>joco</Package>",
	XGAP   := "<Package>xgap</Package>",
	GAPAPP := "<Package>gap.app</Package>",
        FRANCY := "<Package>francy</Package>",
    ),
),

Dependencies := rec(
  GAP := "4.12.0",

  NeededOtherPackages := [["coco2p", "0"]],

  SuggestedOtherPackages := [],

  ExternalConditions := []

),

AvailabilityTest := ReturnTrue,


# BannerString := Concatenation(
#     "----------------------------------------------------------------\n",
#     "Loading  JOCO ", ~.Version, "\n",
#     "by ",
#     JoinStringsWithSeparator( List( Filtered( ~.Persons, r -> r.IsAuthor ),
#                                     r -> Concatenation(
#         r.FirstNames, " ", r.LastName, " (", r.Email, ")\n" ) ), "   " ),
#     "For help, type: ?JOCO: \n",
#     "----------------------------------------------------------------\n" ),

#TestFile := "tst/testall.tst",

Keywords := ["Jordan configuration", "Jordan scheme",
                "rainbow", "color graph"]

));

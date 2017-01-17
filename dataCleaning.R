## ----attach packages-----------------------------------------------------
library(tidyverse)
library(stringr)
library(readxl)
library(purrr)

## ----get list of data file names-----------------------------------------
boy.file.names <- list.files("babyNamesData/boys", full.names = TRUE)

## ----iterate over file names using map-----------------------------------
map(boy.file.names, excel_sheets)

## ----function to identify sheet with table 1 in the name-----------------
findTable1 <- function(x) {
  str_subset(excel_sheets(x), "Table 1")
}

map(boy.file.names, findTable1)

## ----function to read table one from excel file--------------------------
readTable1 <- function(file) {
  read_excel(file, sheet = findTable1(file), skip = 6)
}

boysNames <- map(boy.file.names, readTable1)
glimpse(boysNames[[1]])

## ----examine the names from the excel sheet------------------------------
names(boysNames[[1]])

## ----cleanup the names---------------------------------------------------
names(boysNames[[1]])
make.names(names(boysNames[[1]]), unique = TRUE)
setNames(boysNames[[1]], make.names(names(boysNames[[1]]), unique = TRUE))
names(boysNames[[1]])

## ----use map to cleanup all the names------------------------------------
boysNames <- map(boysNames,
                 function(x) {
                     setNames(x, make.names(names(x), unique = TRUE))
                 })

## ----remove empty rows---------------------------------------------------
boysNames[[1]]
boysNames[[1]] <- filter(boysNames[[1]], !is.na(Name))
boysNames[[1]]

## ----select just the columns of interest---------------------------------
boysNames[[1]]
boysNames[[1]] <- select(boysNames[[1]], Name, Name.1, Count, Count.1)
boysNames[[1]]

## ----stack to two halves of the data-------------------------------------
boysNames[[1]]
bind_rows(select(boysNames[[1]], Name, Count),
          select(boysNames[[1]], Name = Name.1, Count = Count.1))


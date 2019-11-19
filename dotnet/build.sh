#!/bin/sh

cssg compile
dotnet restore
dotnet test
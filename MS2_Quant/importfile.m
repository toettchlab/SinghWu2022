function AlignedDataS5 = importfile(workbookFile, sheetName, dataLines)
%IMPORTFILE Import data from a spreadsheet
%  ALIGNEDDATAS5 = IMPORTFILE(FILE) reads data from the first worksheet
%  in the Microsoft Excel spreadsheet file named FILE.  Returns the data
%  as a table.
%
%  ALIGNEDDATAS5 = IMPORTFILE(FILE, SHEET) reads from the specified
%  worksheet.
%
%  ALIGNEDDATAS5 = IMPORTFILE(FILE, SHEET, DATALINES) reads from the
%  specified worksheet for the specified row interval(s). Specify
%  DATALINES as a positive scalar integer or a N-by-2 array of positive
%  scalar integers for dis-contiguous row intervals.
%
%  Example:
%  AlignedDataS5 = importfile("G:\mCh-uBcd-lexy\kni_ShadNull\AveragePool\AlignedData.xlsx", "Sheet6", [2, 208]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 13-Jun-2021 08:19:36

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 2
    dataLines = [2, 208];
end

%% Setup the Import Options
opts = spreadsheetImportOptions("NumVariables", 20);

% Specify sheet and range
opts.Sheet = sheetName;
opts.DataRange = "A" + dataLines(1, 1) + ":T" + dataLines(1, 2);

% Specify column names and types
opts.VariableNames = ["VarName1", "NaN", "NaN1", "VarName4", "VarName5", "VarName6", "NaN2", "NaN3", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20"];
opts.SelectedVariableNames = ["VarName1", "NaN", "NaN1", "VarName4", "VarName5", "VarName6", "NaN2", "NaN3", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Import the data
AlignedDataS5 = readtable(workbookFile, opts, "UseExcel", false);

for idx = 2:size(dataLines, 1)
    opts.DataRange = "A" + dataLines(idx, 1) + ":T" + dataLines(idx, 2);
    tb = readtable(workbookFile, opts, "UseExcel", false);
    AlignedDataS5 = [AlignedDataS5; tb]; %#ok<AGROW>
end

end
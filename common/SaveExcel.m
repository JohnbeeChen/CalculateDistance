function SaveExcel(varargin)
%input [path, data, columnName, rowName]

% p = inputParser;
% ip.addParamValue('SheetNo','sheet1');
sheet = 'sheet1';
if nargin == 5
   sheet = varargin{5}; 
end
str = varargin{1};
data = varargin{2};
sz = size(data);
colum_name = varargin{3};
row_name = varargin{4};
if isempty(colum_name)&&isempty(row_name)
    data_excel = num2cell(data);   
elseif ~isempty(colum_name)&&isempty(row_name)
    data_excel = cell(sz(1)+1,sz(2));
    data_excel(1,1:end) = colum_name;
    data_excel(2:end,1:end) = num2cell(data);
elseif isempty(colum_name)&& ~isempty(row_name)
    data_excel = cell(sz(1),sz(2)+1);
    data_excel(1:end,1) = row_name;
    data_excel(1:end,2:end) = num2cell(data);    
elseif ~isempty(colum_name)&&isempty(row_name)
    data_excel = cell(sz(1)+1,sz(2)+1);
    data_excel(1,2:end) = colum_name;
    data_excel(2:end,1) = row_name;
    data_excel(2:end,2:end) = num2cell(data);
end
xlswrite(str,data_excel,sheet);
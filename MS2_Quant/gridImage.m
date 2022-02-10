function gridImage(secondlevelTIFF,px)
% input image and grid pixel distance
imshow(secondlevelTIFF);
axis on;
[rows, columns, ~] = size(secondlevelTIFF);
hold on;
for row = 1 : px : rows
  line([1, columns], [row, row], 'Color', 'r');
end
for col = 1 : px : columns
  line([col, col], [1, rows], 'Color', 'r');
end

end
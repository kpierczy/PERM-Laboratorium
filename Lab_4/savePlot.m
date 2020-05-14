% saves matlab plot, that's recently used (have to be open) to name.pdf on 1 A4 page.
% param name : name of PDF file to be saved
function [] = savePlot(name)
% get handle to plot
h = gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h, name, '-dpng', '-r1000')
end


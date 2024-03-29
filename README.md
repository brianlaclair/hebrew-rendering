# Hebrew Rendering for GameMaker: Studio 2
functionality for drawing Hebrew strings in GameMaker: Studio 2 based games and programs.


#### Font Choice + Setup
You'll need to use a font which includes Hebrew characters - many do, but not all!
Once you select a font, you'll need to add new ranges to it.
The ranges you need to add are: 1424 - 1535 *AND* 64298 - 64298

I've included an example font file which is set up correctly - simply drag and drop this into the GMS2 IDE and press "Regenerate" on the font window.

Make sure to call `draw_set_font([yourHebrewFontName]);` before trying to draw a Hebrew string. 

#### Drawing a Hebrew String
You can draw Hebrew text by calling

    draw_text_hebrew(x, y, string);
   
   This function should be used as you would use `draw_text`.
  This function is responsive to default GameMaker draw settings like `draw_set_text`, `draw_set_halign`, and `draw_set_alpha`.
#### Known Limitations and Issues
- Can only draw one line of text at a time (linebreaks currently are not recognized by placement of the nekudos)
- Currently does not have an extended mode for rotation, scaling, etc.

- Certain characters nekudos are slighly misplaced, though within reasonable limits - if you'd like to contribute to these functions, manual adjustments as found while drawing nekudos is the most impactful place to do so!

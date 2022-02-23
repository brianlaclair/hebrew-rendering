//
//	Hebrew Rendering Script for GameMaker: Studio 2
//	See https://github.com/brianlaclair/hebrew-rendering/ for documentation, updates, issues, and license
//

/// @function				draw_text_hebrew(x, y, string);
/// @param {integer} x		x coord to draw the string at
/// @param {integer} y		y coord to draw the string at
/// @param {string}	string	the hebrew string to draw	
function draw_text_hebrew(x, y, str) {
	
	var text_output		= "";
	var length			= string_length(str);
	
	// Hebrew accent characters - we use this to detect accents for batching
	var accent_array	= ["ָ", "ַ", "ּ", "ֵ", "ֶ", "ְ", "ֹ", "ִ", "ֻ", "ֲ", "ֳ", "ֱ"];

	var batch_array		= [];
	var batch_ittr		= 0;
	
	// Used to correctly draw the Hebrew accents on top of the non-accented text with different horizontal alignments
	var accent_offset	= 0;
	
	// Calculate the accent offset based on the halign mode
	switch (draw_get_halign()) {
		case fa_center:
			accent_offset = -string_width(str) / 2;
			break;
		case fa_right:
			accent_offset = -string_width(str);
			break;
	}
	
	// Batch all letter and accent combos into a multi-dimensional array
	for(_i = 1; _i < length + 1; _i++) {
		
		array_push(batch_array, [string_char_at(str, _i)])
		
		// If the next character is in our accent array, we add it to this batch - when we reach a character that is NOT in our array, it will move on in the for loop.
		while (_i + 1 != length && in_array(string_char_at(str, _i+1), accent_array)) {
		
			array_push(batch_array[batch_ittr], string_char_at(str, _i+1));
			_i++;
		
		}
		
		// Keeps track of our batch that we may be writing to as we skip through characters in the length of the string
		batch_ittr++;
		
	}

	// Reverse the array we just created - while Hebrew strings in the IDE navigate correctly, Hebrew strings are read backwards by the runtime (or correctly depending on which way you're looking at it 😅)
	batch_array = array_reverse(batch_array);
	
	// Cool! Now we have the input reversed AND know what characters the accents belong to
	// So let's put it back together
	var arr_length = array_length(batch_array);
	for (_i = 0; _i < arr_length; _i++) {
		
		// Math for placing accents
		var len_before	= string_width(text_output);
		var this_char	= batch_array[_i][0];
		var char_width	= string_width(batch_array[_i][0]);
		
		// Add the character to our regular output string
		text_output		+= this_char; 
		
		// More math for placing accents
		var len_after	= string_width(text_output);
		
		// Check for an accent batched with this character
		if (array_length(batch_array[_i]) > 1) {
			
			// If there are accents batched with this character, we're going to draw them all right now
			for (_acc = 1; _acc < array_length(batch_array[_i]); _acc++) {
				
				var accent_width	= string_width(batch_array[_i][_acc]);
				var diff			= len_after - len_before;
				
				// Regular drawing position
				var fin_pos			= len_before + (diff / 3);
				
				// Adjustments for certain cases - this is incomplete
				if (batch_array[_i][_acc] == accent_array[2] || this_char == "ך" || this_char == "ן" || this_char == "ץ" || this_char == "ש" || in_array("ׁ", batch_array[_i]) || in_array("ׂ", batch_array[_i])) {   	
					
					fin_pos			= len_before;
					
					if (this_char == "ן" || this_char == "ץ") {
						fin_pos		= len_before - (diff / 3);
					}
					
					if (in_array("ׁ", batch_array[_i]) || in_array("ׂ", batch_array[_i])) {
						var _wwi	= string_width("ש");
						fin_pos		= len_after + (_wwi / 4);
					}
					
				}
				
				// Actually draws the accent that we're handling
				draw_text(x + accent_offset + fin_pos, y, batch_array[_i][_acc]);
			}
		}
	}
	
	// Draws the non-accented characters
	draw_text(x, y, text_output);
}

/// @function				array_reverse(array);
/// @param {array} array	the array to reverse
/// @returns {array}		the reversed array
function array_reverse(array) {
	
	var _return = [];
	
	var _array_length = array_length(array) - 1;
	
	for (_i = _array_length; _i > -1; _i--) {
		
		array_push(_return, array[_i]);
		
	}
	
	return _return;
		
}

/// @function					in_array(needle, haystack);
/// @param {variable} needle	a var of any kind to search for
/// @param {array} haystack		the array to search for the needle in
/// @returns {boolean}
function in_array(needle, haystack) {
	
	for(i = 0; i < array_length(haystack); i++) {
	
		if (haystack[i] == needle) {
			return true;
		}
		
	}
	
	return false;

}
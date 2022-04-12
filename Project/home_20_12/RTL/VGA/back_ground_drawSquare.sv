//-- feb 2021 add all colors square 
// (c) Technion IIT, Department of Electrical Engineering 2021


module	back_ground_drawSquare(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] pixelX,
					input logic	[10:0] pixelY,

					output logic [7:0] BG_RGB,
					output logic boardersDR,
					output logic seaDR
);

const int xFrameSize	= 635;
const int yFrameSize	= 475;
const int bracketOffset = 30;

logic [2:0] redBits;
logic [2:0] greenBits;
logic [1:0] blueBits;

localparam logic [2:0] BLACK_COLOR = 3'b000; // bitmap of a dark color (black)
localparam logic [2:0] WHITE_COLOR = 3'b111; // bitmap of a light color (white)

localparam int BLACK_TOP_Y = 0;
localparam int BLACK_LEFT_X = 0;

localparam int GREEN_RIGHT_X = 32;

localparam int BLUE_TOP_Y = 445;
localparam int BLUE_LEFT_X = 0;

// this is a block to generate the background 
//it has four sub modules : 
	// 1. draw the yellow borders
	// 2. draw four lines with "bracketOffset" offset from the border 
	// 3. draw a black background	
 
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
				redBits <= BLACK_COLOR;	
				greenBits <= BLACK_COLOR;	
				blueBits <= BLACK_COLOR;	 
	end 
	else begin

	// defaults 
		greenBits <= BLACK_COLOR; 
		redBits <= BLACK_COLOR;
		blueBits <= BLACK_COLOR;
		boardersDR <= 1'b0;
		seaDR <= 1'b0;
					
	// 1. draw the yellow borders 
		if (pixelX == 0 || pixelY == 0  || pixelX == xFrameSize || pixelY == yFrameSize)
		begin 
			redBits <= BLACK_COLOR;	
			greenBits <= WHITE_COLOR;	
			blueBits <= WHITE_COLOR;
		end
		
	// 2. draw  four lines with "bracketOffset" offset from the border 
		else if(pixelX == bracketOffset || 
		        pixelY == bracketOffset ||
				  pixelX == (xFrameSize-bracketOffset) || 
				  pixelY == (yFrameSize-bracketOffset)) 
				begin 
					redBits <= WHITE_COLOR;	
					greenBits <= WHITE_COLOR;	
					blueBits <= WHITE_COLOR;
					boardersDR <= 1'b1; // pulse if drawing the boarders 
				end
	
		else if(pixelX > BLACK_LEFT_X  && pixelY > BLACK_TOP_Y) 
			begin
				redBits <= BLACK_COLOR;	
				greenBits <= BLACK_COLOR;	
				blueBits <= BLACK_COLOR;	
			end				
				
		
	BG_RGB =  {redBits , greenBits , blueBits} ; //collect color nibbles to an 8 bit word 
	end; 	
end 
endmodule


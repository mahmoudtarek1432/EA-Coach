//+------------------------------------------------------------------+
//|                   Chart Comment Box EA (MQL5)                    |
//|                 Displays a custom message on chart               |
//+------------------------------------------------------------------+
#property strict

//---- Inputs
input string  CommentText      = "Welcome to your trading chart!";
input color   CommentColor     = clrWhite;
input int     FontSize         = 14;
input int     X_Position       = 10;   // Distance from left edge
input int     Y_Position       = 30;   // Distance from top edge

//---- Object name
string CommentName = "ChartCommentBox";

//+------------------------------------------------------------------+
//| Expert initialization                                            |
//+------------------------------------------------------------------+
int OnInit()
{
   // Create text label on chart
   if(!ObjectCreate(0, CommentName, OBJ_LABEL, 0, 0, 0))
   {
      Print("Failed to create label. Error: ", GetLastError());
      return(INIT_FAILED);
   }

   // Set text properties
   ObjectSetString(0, CommentName, OBJPROP_TEXT, CommentText);
   ObjectSetInteger(0, CommentName, OBJPROP_COLOR, CommentColor);
   ObjectSetInteger(0, CommentName, OBJPROP_FONTSIZE, FontSize);
   ObjectSetInteger(0, CommentName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, CommentName, OBJPROP_XDISTANCE, X_Position);
   ObjectSetInteger(0, CommentName, OBJPROP_YDISTANCE, Y_Position);
   ObjectSetString(0, CommentName, OBJPROP_FONT, "Arial Bold");

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization                                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Delete text label when EA is removed
   ObjectDelete(0, CommentName);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // (Optional) You can dynamically update the text here
   // Example: display current Bid price
   // string dynamicText = "Bid Price: " + DoubleToString(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   // ObjectSetString(0, CommentName, OBJPROP_TEXT, dynamicText);
}

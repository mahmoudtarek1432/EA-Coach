#include "Inputs.mqh";

//Functions for the indication table

void TableDestruction(){
    if(ObjectFind(0,"DailyBalanceObjKey")>=0) ObjectDelete(0,"DailyBalanceObjKey");
    if(ObjectFind(0,"DailyBalanceObjValue")>=0) ObjectDelete(0,"DailyBalanceObjValue");
    
    if(ObjectFind(0,"unrealizedObjKey")>=0) ObjectDelete(0,"unrealizedObjKey");
    if(ObjectFind(0,"unrealizedObjValue")>=0) ObjectDelete(0,"unrealizedObjValue");
}

void CreateTable(int _rows,int _cols, Inputs& inputs)
  {
      double realizedDailyBalance = GetDailyBalance();
      double UnrealizedDailyBalance = inputs.DailyDrawdownLimit + NormalizeDouble(GetDailyBalance() + GetUnrealizedReturns(), 2);
      
      
      CreateRow(1, "Daily Balance", realizedDailyBalance , "DailyBalanceObj", inputs);
      CreateRow(2, "Remaining drawdown", UnrealizedDailyBalance, "unrealizedObj",inputs);
  }
  
  void CreateRow(int _row, string _keyText, string _valueText, string name, Inputs& inputs){
 
      if(ObjectFind(0,name+"Key")<0)
           ObjectCreate(0,name+"Key",OBJ_LABEL,0,0,0);
           
      ObjectSetInteger(0,name+"Key",OBJPROP_CORNER,inputs.TableCorner);
      ObjectSetInteger(0,name+"Key",OBJPROP_XDISTANCE,inputs.TableXDistance - (20 + (0 * inputs.CellWidth)));
      ObjectSetInteger(0,name+"Key",OBJPROP_YDISTANCE,inputs.TableYDistance  + (_row * inputs.CellHeight));
      ObjectSetInteger(0,name+"Key",OBJPROP_FONTSIZE,inputs.CellFontSize);
      ObjectSetString(0,name+"Key",OBJPROP_TEXT, _keyText);
      ObjectSetInteger(0,name+"Key",OBJPROP_COLOR,clrWhite);
      ObjectSetInteger(0,name+"Key",OBJPROP_SELECTABLE,false);
      
       if(ObjectFind(0,name+"Value")<0)
           ObjectCreate(0,name+"Value",OBJ_LABEL,0,0,0);
           
      ObjectSetInteger(0,name+"Value",OBJPROP_CORNER,inputs.TableCorner);
      ObjectSetInteger(0,name+"Value",OBJPROP_XDISTANCE,inputs.TableXDistance - (20 + (1 * inputs.CellWidth)));
      ObjectSetInteger(0,name+"Value",OBJPROP_YDISTANCE,inputs.TableYDistance  + (_row * inputs.CellHeight));
      ObjectSetInteger(0,name+"Value",OBJPROP_FONTSIZE,inputs.CellFontSize);
      ObjectSetString(0,name+"Value",OBJPROP_TEXT, _valueText);
      ObjectSetInteger(0,name+"Value",OBJPROP_COLOR,clrWhite);
      ObjectSetInteger(0,name+"Value",OBJPROP_SELECTABLE,false);
 }


double GetDailyBalance()
{
   double daily_balance = 0.0;
   datetime day_start = iTime(_Symbol, PERIOD_D1, 0); // start of the current day

   HistorySelect(day_start, TimeCurrent()); // select today's history

   int total = HistoryDealsTotal();
   for(int i = 0; i < total; i++)
   {
      ulong deal_ticket = HistoryDealGetTicket(i);
      if(deal_ticket > 0)
      {
         string symbol = HistoryDealGetString(deal_ticket, DEAL_SYMBOL);
         if(symbol == _Symbol)
         {
            double profit = HistoryDealGetDouble(deal_ticket, DEAL_PROFIT);
            double swap   = HistoryDealGetDouble(deal_ticket, DEAL_SWAP);
            double commission = HistoryDealGetDouble(deal_ticket, DEAL_COMMISSION);
            datetime deal_time = (datetime)HistoryDealGetInteger(deal_ticket, DEAL_TIME);
            uint deal_entry = HistoryDealGetInteger(deal_ticket, DEAL_ENTRY);

            // Only include closed position results (DEAL_ENTRY_OUT)
            if(deal_time >= day_start && deal_entry == DEAL_ENTRY_OUT)
            {
               daily_balance += profit + swap + commission;
            }
         }
      }
   }

   return daily_balance;
}

double GetUnrealizedReturns(){
double unrealized = 0;
int total_positions = PositionsTotal();
   for(int i = 0; i < total_positions; i++)
   {
      string symbol = PositionGetSymbol(i);
      if(PositionSelect(symbol) && symbol == _Symbol)
      {
         double profit = PositionGetDouble(POSITION_PROFIT);
         unrealized += profit;
      }
   }
   return unrealized;
}
 
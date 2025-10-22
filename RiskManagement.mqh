//function to send a notification in case a stop loss was placed over the trade risk limit.
#include "IndicationTable.mqh"
#include <Trade/Trade.mqh>
CTrade trade;

void OverRiskAlert(Inputs& inputs){
   int total_positions = PositionsTotal();
   for(int i = 0; i < total_positions; i++)
   {
      string symbol = PositionGetSymbol(i);
      if(PositionSelect(symbol) && symbol == _Symbol)
      {
         double SL = PositionGetDouble(POSITION_SL);
         double volume = PositionGetDouble(POSITION_VOLUME);
         double price = PositionGetDouble(POSITION_PRICE_OPEN);
         
         if(SL <= 0)
            continue;
         
         double positionRisk = (volume*100) * MathAbs(price - SL);
         
         if(positionRisk > inputs.TradeRiskLimit){
            Alert("You are risking too much!!! total risk is " + positionRisk);
         }
      } 
   }
}

void OneTradeRule(){
   int total_positions = PositionsTotal();
   
   if(total_positions > 1){
      Alert("DONT OPEN MULTIPLE TRADES, STAY DECIPLINED");
   }
}

void DrawdownProtection(Inputs& inputs){
   double dailyBalance = NormalizeDouble(GetDailyBalance() + GetUnrealizedReturns(), 2);
   int total_positions = PositionsTotal();
   
   if((inputs.DailyDrawdownLimit / 2) >= dailyBalance && total_positions > 0){
      CloseAllPositions();
      Alert("DAILY DRAWDOWN PROTECTION ACTIVATED. NO TRADING FOR THE DAY...");
      SendDailyLoseEmail();
   }
}

void CloseAllPositions()
{
   int total = PositionsTotal();
   for(int i = total - 1; i >= 0; i--)
   {
      string symbol = PositionGetSymbol(i);
      if(PositionSelect(symbol))
      {
         ulong ticket = PositionGetInteger(POSITION_TICKET);
         double volume = PositionGetDouble(POSITION_VOLUME);
         long type = PositionGetInteger(POSITION_TYPE);
         
         // Close buy
         if(type == POSITION_TYPE_BUY)
         {
            if(trade.PositionClose(symbol))
               Print("Closed BUY position on ", symbol);
            else
               Print("Failed to close BUY on ", symbol, ". Error: ", GetLastError());
         }
         // Close sell
         else if(type == POSITION_TYPE_SELL)
         {
            if(trade.PositionClose(symbol))
               Print("Closed SELL position on ", symbol);
            else
               Print("Failed to close SELL on ", symbol, ". Error: ", GetLastError());
         }
      }
   }
}

void SendDailyLoseEmail(){
   SendMail("Daily Drawdown Protection activated!", "Daily Drawdown Protection activated!");

}
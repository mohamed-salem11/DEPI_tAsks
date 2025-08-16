using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp3
{
    public class SavingAccount : Account
    {
        private DateTime LastGrowthTime { get; set; }
        private const decimal GrowthRatePerSecond = 0.001m;

        public SavingAccount(decimal initialDeposit)
        {
            Balance = initialDeposit;
            LastGrowthTime = DateTime.Now;
        }

        public void ApplyGrowth()
        {
            var now = DateTime.Now;
            var timeElapsedInSeconds = (decimal)(now - LastGrowthTime).TotalSeconds;

            if (timeElapsedInSeconds >= 1)
            {
                decimal growthAmount = timeElapsedInSeconds * GrowthRatePerSecond;
                Balance += growthAmount;
                LastGrowthTime = now;
             
            }
        }
        public decimal CalculateMonthlyInterest()
        {
            return Balance * InterestRate / 12;
        }
        public override bool Withdraw(decimal amount)
        {
            if (amount > Balance)
            {
                Console.WriteLine("Insufficient balance.");
                return false;
            }
            Balance -= amount;
            AddTransaction(new Transaction(amount, "Withdrawal"));
            Console.WriteLine($"Successfully withdrew {amount:C}. New balance is: {Balance:C}");
            return true;
        }
    }

}















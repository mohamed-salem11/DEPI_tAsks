using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp3
{
    public class Transaction
    {
        public decimal Amount { get; set; }
        public string Type { get; set; }
        public DateTime Timestamp { get; set; }

        public Transaction(decimal amount, string type)
        {
            Amount = amount;
            Type = type;
            Timestamp = DateTime.Now;
        }
    }

}


















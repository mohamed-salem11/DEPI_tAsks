using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp3
{
    public class Customer
    {
        public int Id { get; set; }
        public string FullName { get; set; }
        public string NationalId { get; set; }
        public DateTime DateOfBirth { get; set; }
        public List<Account> Accounts { get; set; } = new List<Account>();

        public void UpdateDetails(string newFullName, DateTime newDateOfBirth)
        {
            FullName = newFullName;
            DateOfBirth = newDateOfBirth;
        }

        public decimal GetTotalBalance()
        {
            return Accounts.Sum(a => a.Balance);
        }
    }

}



















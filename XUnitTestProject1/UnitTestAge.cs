using System;
using Xunit;

namespace gudusoft.family
{
    public class UnitTestAge
    {

        [Fact]
        public void TestSayAge()
        {
            person p = new person();
            Assert.Equal("my age is:50", p.sayAge(50));
        }
    }
}
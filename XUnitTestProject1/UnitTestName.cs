using System;
using Xunit;


namespace gudusoft.family
{
    public class UnitTestName
    {
        [Fact]
        public void TestSayName()
        {
            person p = new person();
            Assert.Equal("my name is:wjp", p.sayName("wjp"));
        }
    }
}

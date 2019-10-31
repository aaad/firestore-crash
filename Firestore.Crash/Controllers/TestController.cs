using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Google.Cloud.Firestore;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace Firestore.Crash.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TestController : ControllerBase
    {
        private ILogger<TestController> Logger { get; }
        private FirestoreDb Database { get; }

        public TestController(ILogger<TestController> logger)
        {
            Logger = logger;

            try
            {
                Database = FirestoreDb.Create("testing-profile-crawler");
                Logger?.LogInformation($"Firebase connection established.");
            }
            catch (Exception ex)
            {
                Logger?.LogError($"Firebase can not be reached: {ex.Message}{Environment.NewLine}{ex.StackTrace}");
                throw ex;
            }
        }

        [HttpGet]
        public async Task<ActionResult> Get()
        {
            var collection = Database.Collection("test");

            Logger?.LogInformation($"Start fetching from database.");

            return
                Ok(
                await
                    collection
                    .Limit(1)
                    .StreamAsync()
                    .Select(d => d.ToDictionary())
                    .FirstOrDefault());
        }

    }
}

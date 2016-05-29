{
-- { app = "base-main", deps = {"hydraApi"}, id="0Z7aDFm5", saveas="startup" },
-- { app = "base-tanks", deps = {"hydraApi"}, id="2uq9RYzr", saveas="startup"  },
-- { app = "base-ae", deps = {"hydraApi"}, id="2uq9RYzr", saveas="startup"  },
   { app = "base-energy", deps = {"hydraApi"}, id="energy.lua", saveas="startup"  },
-- { app = "base-bees", deps = {"hydraApi"}, id="qe0ViX8i", saveas="startup"  },
-- { app = "base-ae-dump", deps = {"hydraApi"}, id="hUsQFbpi", saveas="aed"  },
    { app = "base-reactor", deps = {"hydraApi"}, id="reactor.lua", saveas="startup"  },
    { app = "timers", deps = {"hydraApi"}, id="timers.lua", saveas="timers"  },
    { app = "log-reactor", deps = {"hydraApi", "hydraLogApi"}, id="log-reactor.lua", saveas="logr"  },
    { app = "hydraApi", deps = nil, id="hydraapi.lua", saveas=nil, api=true },
    { app = "hydraLogApi", deps = {"hydraApi"}, id="hydraLogApi.lua", saveas=nil, api=true }
}
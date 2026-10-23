-- metals v2 Java indexer uses JDK internal APIs, so --add-exports is required
local cmd = { "metals" }
for _, pkg in ipairs({ "api", "code", "comp", "file", "jvm", "main", "model", "parser", "platform", "tree", "util" }) do
  table.insert(cmd, "-J--add-exports=jdk.compiler/com.sun.tools.javac." .. pkg .. "=ALL-UNNAMED")
end

return {
  cmd = cmd,
  init_options = { statusBarProvider = "off" },
  settings = {
    metals = {
      showImplicitArguments = true,
      showInferredType = true,
      -- Increase Bloop (build server) heap; default can OOM on large repos
      bloopJvmProperties = { "-Xmx6G", "-Xss4m", "-XX:+UseZGC", "-XX:ZUncommitDelay=30", "-XX:ZCollectionInterval=5" },
    },
  },
}

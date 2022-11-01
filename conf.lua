local lto = false
if cli.lto ~= nil then lto = tobool(cli.lto) end

return {
    board = cli.board or "raspi3b",
    lto = lto,
    release = tobool(cli.release) or false,
    prog = cli.prog or "hello",
    dc = cli.dc or "gdc",
}

local source = {}

function source.new()
    return setmetatable({}, { __index = source })
end

function source:complete(request, callback)
    local input = string.sub(request.context.cursor_before_line, request.offset)

    local items = {}
    local register_names = '"*+-.:%#/:'
    for i=97, 97+25 do
        register_names = register_names..string.char(i)
    end
    for i=0, 9 do
        register_names = register_names..tostring(i)
    end
    for i = 1, #register_names do
        local reg = vim.fn.getreg(register_names:sub(i, i))
        if string.match(reg, input) then
            table.insert(items, { label = reg:gsub('^%s*(.-)%s*$', '%1') })
        end
    end

    callback({ items = items, isIncomplete = true })
end


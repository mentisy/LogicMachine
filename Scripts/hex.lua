-----------------------------------------------------
------------------- yi functions --------------------
-- https://gist.github.com/yi/01e3ab762838d567e65d --
-----------------------------------------------------

function string.fromhex(str)
    return (str:gsub('..', function (cc)
        return string.char(tonumber(cc, 16))
    end))
end

function string.tohex(str)
    return (str:gsub('.', function (c)
        return string.format('%02X', string.byte(c))
    end))
end

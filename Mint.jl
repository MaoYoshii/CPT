const MOD = 998244353
struct MInt{T} <: Integer
    MInt :: T
    MOD :: typeof(MOD)
    function MInt(a::T) where T
        if 0 ≤ a < MOD
            new{T}(a,MOD)
        else
            new{T}(mod(a,MOD),MOD)
        end
    end
end
new(a) = new{typeof(a)}(a)
value(x::MInt) = x.MInt

function Base.show(io::IO, x::MInt)
    print( io, value(x))
end

Base.:<<(a::MInt, b::Int) = MInt(value(a)<<b)

Base.:>>(a::MInt, b::Int) = MInt(value(a)>>b)

Base.:+(a::MInt, b::Int) = MInt(value(a)+b)
Base.:+(a::Int, b::MInt) = MInt(a+value(b))
function Base.:+(a::MInt, b::MInt)
    c = value(a)+value(b)
    if c > MOD
        return MInt(c-MOD)
    else
        return MInt(c)
    end
end
Base.:-(a::MInt, b::Int) = MInt(value(a)-b)
Base.:-(a::Int, b::MInt) = MInt(a-value(b))
function Base.:-(a::MInt, b::MInt)
    c = value(a)-value(b)
    if c < 0
        return MInt(c+MOD)
    else
        return MInt(c)
    end
end

Base.:*(a::MInt, b::Int) = MInt(value(a)*b)
Base.:*(a::Int, b::MInt) = MInt(a*value(b))
Base.:*(a::MInt, b::MInt) = MInt(value(a)*value(b))

Base.:^(a::MInt, b::Int) = if b == 0
    return MInt(1)
elseif b == 1
    return a
elseif b & 1 != 0
    b -= 1
    return (a^b)*a
else
    b >>= 1
    c = a^b
    return c*c
end
Base.:^(a::Int, b::MInt) = if value(b) == 0
    return 1
elseif value(b) == 1
    return MInt(a)
elseif value(b) & 1 != 0
    b -= 1
    return (a^value(b))*a
else
    b >>= 1
    c = a^value(b)
    return c*c
end

Base.:^(a::MInt, b::MInt) = if value(b) == 0
    return MInt(1)
elseif value(b) == 1
    return a
elseif value(b) & 1 != 0
    b -= 1
    return (a^value(b))*a
else
    b >>= 1
    c = a^value(b)
    return c*c
end

Base.inv(a::MInt;prime = true) = if prime
    a^(MOD-2)
else
    d,u,v = gcdx(value(a),MOD)
    return MInt(u)
end

Base.:÷(a::MInt, b::Int) = value(a)*inv(MInt(b))
Base.:÷(a::Int, b::MInt) = a*inv(b)
Base.:÷(a::MInt, b::MInt) = a*inv(b)
const MOD = 1000000007
struct MInt{T,S} <: Integer
    MInt :: T
    MOD :: S
    global function _unsafe_mint(a::T,MOD::S) where {T,S}
         new{T,S}(a,MOD)
    end
end
MInt(a,MOD) = _unsafe_mint( ifelse(a<0,a%MOD+MOD,a%MOD),MOD)
MInt(a) = MInt(a,MOD)
value(x::MInt) = x.MInt

function Base.show(io::IO, x::MInt)
    print( io, value(x))
end

Base.:<<(a::MInt, b::Int) = MInt(value(a)<<b)

Base.:>>(a::MInt, b::Int) = _unsafe_mint(value(a)>>b,MOD)

Base.:+(a::MInt, b::Int) = MInt(value(a)+b)
Base.:+(a::Int, b::MInt) = MInt(a+value(b))
Base.:+(a::MInt, b::MInt) = _unsafe_mint( value(a)+value(b) |> x -> ifelse(x > MOD, x-MOD,x),MOD)
Base.:-(a::MInt, b::Int) = MInt(value(a)-b)
Base.:-(a::Int, b::MInt) = MInt(a-value(b))
Base.:+(a::MInt, b::MInt) = _unsafe_mint( value(a)-value(b) |> x -> ifelse(x < 0, x+MOD,x),MOD)

Base.:*(a::MInt, b::Int) = MInt(value(a)*b)
Base.:*(a::Int, b::MInt) = MInt(a*value(b))
Base.:*(a::MInt, b::MInt) = _unsafe_mint( value(a)*value(b)%MOD,MOD)

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

Base.inv(a::MInt) = a^(MOD-2)

Base.:÷(a::MInt, b::Int) = value(a)*inv(MInt(b))
Base.:÷(a::Int, b::MInt) = a*inv(b)
Base.:÷(a::MInt, b::MInt) = a*inv(b)
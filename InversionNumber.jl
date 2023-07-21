struct BIT{T}
    memory :: Vector{T}
    size :: Integer
    function BIT{T}(N) where T
        # memoryを作る
        new{T}(zeros(T,N),N)
    end
end
BIT(N) = BIT{Int}(N) 
size(x::BIT) = x.size
"""
    add(b,idx,x)
    b[idx] += x
"""
function add!(b::BIT,idx,x)
    while idx ≤ b.size
        b.memory[idx] += x
        idx += idx&(-idx)
    end
end

"""
    sum(b,idx)
    b[idx] += x
"""
function sum(b::BIT,idx)
    total = 0
    while idx > 0
        total += b.memory[idx]
        idx -= idx&(-idx)
    end
    total
end

function InverisonNumber(arr)
    N = length(arr)
    bit = BIT(N)
    out = 0
    for n in 1:N
        add!(bit,arr[n],1)
        out += n-sum(bit,arr[n])
    end
    out
end
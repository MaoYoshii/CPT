function prime_numbers(N)
    primes = [2]
    for n in 3:2:N
        sqrtn = sqrt(n) |> floor
        yes = true
        for p in primes
            if p > sqrtn 
                break
            end
            if n % p == 0
                yes = false
                break
            end
        end
        if yes 
            push!(primes,n)
        end
    end  
    primes
end

function prime_numbers_sqrt(N)
    primes = [2]
    MAX = sqrt(N) |> ceil
    for n in 3:2:MAX
        sqrtn = sqrt(n) |> floor
        yes = true
        for p in primes
            if p > sqrtn 
                break
            end
            if n % p == 0
                yes = false
                break
            end
        end
        if yes 
            push!(primes,n)
        end
    end  
    primes
end
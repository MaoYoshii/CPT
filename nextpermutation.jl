function nextpermutation!(array)
    n = length(array)
    # step1. find the largest index k s.t. array[k] < array[k + 1]
    k = 0
    for i in n-1:-1:1
        if array[i] < array[i+1]
            k = i
            break
        end
    end
    if k ≤ 0
        return empty!(array) # もうない
    end

    # step2. find the largest index l ( > k) s.t. array[k] < array[l]
    l = n
    for i in n:-1:k
        if array[k] < array[i]
            l = i
            break
        end
    end

    # step3. swap
    array[k], array[l] = array[l], array[k]
    
    # step4. reverse the sequence from array[k + 1] to array[n]
    reverse!(view(array,(k+1):n))
    
    return array
end
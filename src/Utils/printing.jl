# I know maybe this is not the best way :)
# This is only printing the matches in the givin style
function _print_highlights(text, hint;
        style...
    )

    up_in_bold = uppercase(hint)
    up_text = uppercase(text)

    ci = 1 # current index
    while true
        hr_ = findnext(up_in_bold, up_text, ci)
        
        # No more hint
        if isnothing(hr_)
            print(text[ci:end])
            break;
        end
        
        # no-hint before hint
        print(text[ci:(first(hr_) - 1)])

        # hint
        printstyled(text[hr_]; style...)

        ci = first(hr_) + length(hint)
        ci > length(text) && break
    end
end
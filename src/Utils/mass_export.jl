# Minimal replacement for MassExport package functionality
# Provides macros for bulk exporting module symbols

"""
    @exportall_underscore()

Export all symbols in the current module that start with an underscore (_).

Note: This is used for compatibility with the original MassExport package behavior.
Normally, underscore-prefixed symbols are considered internal and not exported,
but this package's convention uses them for certain utility functions that need
to be accessible to other modules in the MetabolicXploration ecosystem.
"""
macro exportall_underscore()
    mdl = __module__
    names_to_export = [
        name for name in names(mdl, all=true, imported=false) 
        if startswith(string(name), "_") && 
           !startswith(string(name), "__") &&  # Exclude double-underscore (reserved)
           name != Symbol("_")
    ]
    
    if isempty(names_to_export)
        return esc(:(nothing))
    end
    
    return esc(:(export $(names_to_export...)))
end

"""
    @exportall_non_underscore()

Export all symbols in the current module that do NOT start with an underscore.
These are the public API functions.
"""
macro exportall_non_underscore()
    mdl = __module__
    names_to_export = [
        name for name in names(mdl, all=true, imported=false) 
        if !startswith(string(name), "_") && 
           !startswith(string(name), "#") &&  # Exclude compiler-generated names
           name != :eval && 
           name != :include
    ]
    
    if isempty(names_to_export)
        return esc(:(nothing))
    end
    
    return esc(:(export $(names_to_export...)))
end

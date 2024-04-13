module ADTypesChainRulesCoreExt

using ADTypes: ADTypes, AutoChainRules
using ChainRulesCore: HasForwardsMode, HasReverseMode,
                      NoForwardsMode, NoReverseMode,
                      RuleConfig

# see https://juliadiff.org/ChainRulesCore.jl/stable/rule_author/superpowers/ruleconfig.html

function ADTypes.mode(::AutoChainRules{RC}) where {
        RC <: RuleConfig{>:Union{HasForwardsMode, NoReverseMode}}
}
    return ADTypes.ForwardMode()
end

function ADTypes.mode(::AutoChainRules{RC}) where {
        RC <: RuleConfig{>:Union{NoForwardsMode, HasReverseMode}}
}
    return ADTypes.ReverseMode()
end

function ADTypes.mode(::AutoChainRules{RC}) where {
        RC <: RuleConfig{>:Union{HasForwardsMode, HasReverseMode}}
}
    return ADTypes.ForwardOrReverseMode()
end

end

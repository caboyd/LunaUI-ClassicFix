local parent, ns = ...
ns.oUF = {}
ns.oUF.Private = {}

ns.oUF.isClassic = WOW_PROJECT_ID == (WOW_PROJECT_CLASSIC or 2)
ns.oUF.isTBC = WOW_PROJECT_ID == (WOW_PROJECT_BURNING_CRUSADE_CLASSIC or 5)
ns.oUF.isWrath = WOW_PROJECT_ID == (WOW_PROJECT_WRATH_CLASSIC or 11)
ns.oUF.isRetail = WOW_PROJECT_ID == (WOW_PROJECT_MAINLINE or 1)

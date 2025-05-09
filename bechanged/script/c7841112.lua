--セイヴァー・スター・ドラゴン
function c7841112.initial_effect(c)
	aux.AddMaterialCodeList(c,21159309,44508094)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c7841112.mfilter1,c7841112.mfilter2,nil,aux.NonTuner(nil),1,1)
	c:EnableReviveLimit()
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7841112,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c7841112.negcon)
	e2:SetCost(c7841112.negcost)
	e2:SetTarget(c7841112.negtg)
	e2:SetOperation(c7841112.negop)
	c:RegisterEffect(e2)
	--Disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7841112,1))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c7841112.distg)
	e3:SetOperation(c7841112.disop)
	c:RegisterEffect(e3)
	--activate limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c7841112.alop)
	c:RegisterEffect(e4)
	--to extra & Special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(7841112,2))
	e5:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e5:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetTarget(c7841112.sptg)
	e5:SetOperation(c7841112.spop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(7841112,3))
	e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCountLimit(1)
	e6:SetTarget(c7841112.sumtg)
	e6:SetOperation(c7841112.sumop)
	c:RegisterEffect(e6)
end
c7841112.material_type=TYPE_SYNCHRO
function c7841112.mfilter1(c)
	return c:IsCode(21159309)
end
function c7841112.mfilter2(c,syncard,c1)
	return c:IsCode(44508094) and (c:IsTuner(syncard) or c1:IsTuner(syncard))
end
function c7841112.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp and Duel.IsChainNegatable(ev)
end
function c7841112.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c7841112.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c7841112.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
	e:GetHandler():RegisterFlagEffect(7841112,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
function c7841112.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.NegateMonsterFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c7841112.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		Duel.MajesticCopy(c,tc)
	end
end
function c7841112.alop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetOwner()==e:GetOwner() and not re:IsHasProperty(EFFECT_FLAG_INITIAL) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(1,1)
		e1:SetValue(c7841112.aclimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1)
	end
end
function c7841112.aclimit(e,re,tp)
	return re:GetOwner()==e:GetOwner() and not re:IsHasProperty(EFFECT_FLAG_INITIAL)
end
function c7841112.spfilter(c,e,tp)
	return c:IsCode(44508094) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7841112.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c7841112.spfilter(chkc,e,tp) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c7841112.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c7841112.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsExtraDeckMonster() and Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)~=0
		and c:IsLocation(LOCATION_EXTRA) and tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c7841112.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetFlagEffect(7841112)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c7841112.sumop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
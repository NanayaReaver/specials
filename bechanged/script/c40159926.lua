--ミラー・リゾネーター
---@param c Card
function c40159926.initial_effect(c)
	aux.AddCodeList(c,70902743)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40159926,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,40159926)
	e1:SetCondition(c40159926.condition)
	e1:SetTarget(c40159926.target)
	e1:SetOperation(c40159926.operation)
	c:RegisterEffect(e1)
	--synchro level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40159926,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c40159926.lvtg)
	e2:SetOperation(c40159926.lvop)
	c:RegisterEffect(e2)
end
function c40159926.cfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function c40159926.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c40159926.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c40159926.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c40159926.setfilter(c)
	return aux.IsCodeListed(c,70902743) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c40159926.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsSetCard),tp,LOCATION_MZONE,0,1,nil,70902743)
		and Duel.IsExistingMatchingCard(c40159926.setfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(40159926,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c40159926.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
		end
	end
end
function c40159926.lvfilter(c)
	return c:IsFaceup() and c:GetOriginalLevel()>0
end
function c40159926.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c40159926.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40159926.lvfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c40159926.lvfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c40159926.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SYNCHRO_LEVEL)
		e1:SetValue(tc:GetOriginalLevel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		c:SetHint(CHINT_NUMBER,tc:GetOriginalLevel())
	end
end

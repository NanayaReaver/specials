--森羅の隠蜜 スナッフ
function c47741109.initial_effect(c)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47741109,0))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c47741109.condition)
	e1:SetTarget(c47741109.target)
	e1:SetOperation(c47741109.operation)
	c:RegisterEffect(e1)
end
function c47741109.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) or (c:IsPreviousLocation(LOCATION_DECK) and	c:IsReason(REASON_REVEAL))
end
function c47741109.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c47741109.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsRace(RACE_PLANT) then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
	elseif tc:IsRace(RACE_ALL-RACE_CREATORGOD) then
		if Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP) then
			CUNGUI.regsplimit(tc,tp)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	else
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

--アロマセラフィ－アンゼリカ
--Aromaseraphy Angelica
--Scripted by Eerie Code
function c16759958.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16759958,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,16759958)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c16759958.rccost)
	e1:SetTarget(c16759958.rctg)
	e1:SetOperation(c16759958.rcop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16759958,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,16759958+1)
	e2:SetCondition(c16759958.spcon)
	e2:SetTarget(c16759958.sptg)
	e2:SetOperation(c16759958.spop)
	c:RegisterEffect(e2)
end

function c16759958.rccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c16759958.rcfil(c)
	return c:IsSetCard(0xc9) and c:IsType(TYPE_MONSTER) and c:IsAttackAbove(1)
end
function c16759958.rctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c16759958.rcfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16759958.rcfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c16759958.rcfil,tp,LOCATION_GRAVE,0,1,1,nil)
	local atk=g:GetFirst():GetAttack()
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function c16759958.rcop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if tc:IsRelateToEffect(e) then
		Duel.Recover(p,tc:GetAttack(),REASON_EFFECT)
	end
end

function c16759958.spfil(c)
	return c:IsFaceup() and c:IsSetCard(0xc9)
end
function c16759958.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>Duel.GetLP(1-tp) and Duel.IsExistingTarget(c16759958.spfil,tp,LOCATION_MZONE,0,1,nil)
end
function c16759958.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c16759958.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end

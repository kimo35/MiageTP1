Class commande.BO.Voiture Extends Ens.BusinessOperation
{

Property Adapter As Ens.OutboundAdapter;

Parameter ADAPTER = "Ens.OutboundAdapter";

Parameter INVOCATION = "Queue";

Method creerVoiture(pRequest As commande.msg.creerVoitureDmde, Output pResponse As commande.msg.creerVoitureRpse) As %Status
{
    
    set pResponse = ##class(commande.msg.creerVoitureRpse).%New()
    set voiture = ##class(commande.data.Voiture).%New()
    do ##class(commande.Transform.WsVoitureToVoiture).Transform(pRequest.voiture,.voiture)
    set tsc = voiture.%Save()
    if tsc {
        set pResponse.codeRetour = "OK"
    }
    else{
        set pResponse.codeRetour = "KO"
        set pResponse.libErreur = "Impossible de cr?er la voiture : "_tsc
    }

    Quit $$$OK
}

Method deleteVoiture(pRequest As commande.msg.deleteVoitureDmde, Output pResponse As commande.msg.deleteVoitureRpse) As %Status
{
    Set tsc = $$$OK
    set pResponse = ##class(commande.msg.deleteVoitureRpse).%New()
    
    if (##class(commande.data.Voiture).consulterParPlaqueExists(pRequest.plaque,.idVoiture)){
        set tsc = ##class(commande.data.Voiture).%DeleteId(idVoiture)
        if tsc {
            set pResponse.codeRetour = "OK"
        }
        else {
            set pResponse.codeRetour = "NNKO"
            set pResponse.libErreur = "Erreur Technique : "_tsc
        }
    }
    else {
        set pResponse.codeRetour = "NNKO"
        set pResponse.libErreur = "Voiture dosn't exist"

    }
    Quit $$$OK
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="commande.msg.creerVoitureDmde">
        <Method>creerVoiture</Method>
    </MapItem>

    <MapItem MessageType="commande.msg.deleteVoitureDmde">
        <Method>deleteVoiture</Method>
    </MapItem>
</MapItems>
}

}


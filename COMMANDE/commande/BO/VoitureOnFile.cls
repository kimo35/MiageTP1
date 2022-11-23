/// Description
Class BO.VoitureOnFile Extends Ens.BusinessOperation
{

Property Adapter As EnsLib.File.OutboundAdapter;

Parameter ADAPTER = "EnsLib.File.OutboundAdapter";

Parameter INVOCATION = "Queue";

Method CreationVoitureFile(pRequest As commande.msg.CreationVoitureFileDmde, Output pResponse As commande.msg.CreationVoitureFileRpse) As %Status
{
    
    set pResponse = ##class(commande.msg.CreationVoitureFileRpse).%New()
    set Stream = ##class(%Library.FileBinaryStream).%New()
    do Stream.Write(pRequest.voiture.marque_ ";"_pRequest.voiture.modele_ ";"_pRequest.voiture.plaque)

    DO ..Adapter.PutStream("VoitureOnFile"_".csv", Stream)

    Quit $$$OK
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="commande.msg.CreationVoitureFileDmde">
        <Method>CreationVoitureFile</Method>
    </MapItem>
</MapItems>
}

}

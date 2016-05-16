def ontology():
    from SPARQLWrapper import SPARQLWrapper, JSON
    name = "Donald_Byrd"
    sparql = SPARQLWrapper("http://dbpedia.org/sparql")
    query_1 = """
    PREFIX dbo: <http://dbpedia.org/property/>
    SELECT ?birthPlace
    WHERE { <http://dbpedia.org/resource/%s> dbo:birthPlace ?birthPlace }
"""
    sparql.setQuery(query_1%(name))
    sparql.setReturnFormat(JSON)
    results = sparql.query().convert()
    return results

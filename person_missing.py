def person_missing():
    infile = open('/Users/ReneeHao/Documents/Data Cleaning Final Project/person_missing_info.csv','r')
    outfile = open('/Users/ReneeHao/Documents/Data Cleaning Final Project/person_complete_1.txt','w')
    from SPARQLWrapper import SPARQLWrapper, JSON
    sparql = SPARQLWrapper("http://dbpedia.org/sparql")
    aline = infile.readline()
    aline = infile.readline()
    cnt_gender = 0
    cnt_birthDate = 0
    cnt_deathDate = 0
    cnt_birthPlace = 0
    while (aline != ''):
        tmp = aline.split(',')
        p_name_0 = tmp[1].replace('"','').strip()
        p_name = p_name_0.replace(' ','_').strip()
        gender = tmp[2].strip()
        birthDate = tmp[3].strip()
        deathDate = tmp[4].strip()
        if (len(tmp) == 6):
            birthPlace = tmp[5].replace('"','').strip()
        else:
            birthPlace = (tmp[5] + ', ' + tmp[6]).replace('"','').strip()
        if (birthPlace == 'NULL'):
            try:
                query_1 = """
                PREFIX dbp: <http://dbpedia.org/property/>
                SELECT ?birthPlace
                WHERE { <http://dbpedia.org/resource/%s> dbp:birthPlace ?birthPlace }
            """
                sparql.setQuery(query_1%(p_name))
                sparql.setReturnFormat(JSON)
                results = sparql.query().convert()
                if (results["results"]["bindings"] != []):
                    birthPlace = str(results["results"]["bindings"][0]["birthPlace"]["value"])
                    cnt_birthPlace = cnt_birthPlace + 1
                else:
                    query_1 = """
                    PREFIX dbp: <http://dbpedia.org/property/>
                    SELECT ?birthPlace
                    WHERE { <http://dbpedia.org/resource/%s> dbp:placeOfBirth ?birthPlace }
                """
                    sparql.setQuery(query_1%(p_name))
                    sparql.setReturnFormat(JSON)
                    results = sparql.query().convert()
                    if (results["results"]["bindings"] != []):
                        birthPlace = str(results["results"]["bindings"][0]["birthPlace"]["value"])
                        cnt_birthPlace = cnt_birthPlace + 1
            except UnicodeEncodeError:
                print p_name_0

        if (birthDate == 'NULL'):
            try:
                query_2 = """
                PREFIX dbp: <http://dbpedia.org/property/>
                SELECT ?birthDate
                WHERE { <http://dbpedia.org/resource/%s> dbp:birthDate ?birthDate }
            """
                sparql.setQuery(query_2%(p_name))
                sparql.setReturnFormat(JSON)
                results = sparql.query().convert()
                if (results["results"]["bindings"] != []):
                    birthDate = str(results["results"]["bindings"][0]["birthDate"]["value"])
                    cnt_birthDate = cnt_birthDate + 1
            except UnicodeEncodeError:
                print p_name_0

        if (deathDate == 'NULL'):
            try:
                query_3 = """
                PREFIX dbp: <http://dbpedia.org/property/>
                SELECT ?deathDate
                WHERE { <http://dbpedia.org/resource/%s> dbp:deathDate ?deathDate }
            """
                sparql.setQuery(query_3%(p_name))
                sparql.setReturnFormat(JSON)
                results = sparql.query().convert()
                if (results["results"]["bindings"] != []):
                    deathDate = str(results["results"]["bindings"][0]["deathDate"]["value"])
                    cnt_deathDate = cnt_deathDate + 1
            except UnicodeEncodeError:
                print p_name_0

        if (gender == 'NULL'):
            try:
                query_4 = """
                PREFIX dbp: <http://dbpedia.org/property/>
                SELECT ?gender
                WHERE { <http://dbpedia.org/resource/%s> dbp:gender ?gender}
            """
                sparql.setQuery(query_4%(p_name))
                sparql.setReturnFormat(JSON)
                results = sparql.query().convert()
                if (results["results"]["bindings"] != []):
                    gender = str(results["results"]["bindings"][0]["gender"]["value"])
                    cnt_gender = cnt_gender + 1
            except UnicodeEncodeError:
                print p_name_0


        try:
            new_line = tmp[0] + ',' + p_name_0 + ',' + gender + ',' + birthDate + ',' + deathDate + ',' + birthPlace + '\n'
        except UnicodeEncodeError:
            print p_name_0

            
        outfile.write(new_line)
        aline = infile.readline()

    infile.close()
    outfile.close()
    stats = {'gender': cnt_gender, "birthPlace": cnt_birthPlace, "birthDate": cnt_birthDate, "deathDate": cnt_deathDate}
    return stats

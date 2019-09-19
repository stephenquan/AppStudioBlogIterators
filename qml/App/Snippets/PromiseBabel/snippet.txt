try {
    showUser( yield download( "GET", "https://www.arcgis.com/sharing/rest/community/users/squan888?f=pjson" ) )
    showUser( yield download( "GET", "https://www.arcgis.com/sharing/rest/community/users/appstudio_samples?f=pjson" ) )
    showUser( yield download( "GET", "https://www.arcgis.com/sharing/rest/community/users/appstudio_templates?f=pjson" ) )
} catch (error) {
    console.log("Caught Exception: ", error.message)
    console.log("Stack: ", error.stack)
    throw error
}

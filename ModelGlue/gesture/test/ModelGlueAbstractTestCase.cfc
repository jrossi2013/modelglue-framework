<cfcomponent extends="mxunit.framework.TestCase">

	<cfset this.coldspringPath = "/ModelGlue/gesture/test/ColdSpring.xml" />
	<cfset variables.mg = "">

	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">	
	</cffunction>
	
	<cffunction name="createBootstrapper" access="private">
		<cfargument name="coldspringPath" default="#this.coldspringPath#">
		<cfargument name="modelGlueBeanName" default="modelglue.ModelGlue">
		<cfset var bootstrapper = createObject("component", "ModelGlue.gesture.loading.ColdSpringBootstrapper")>
		<cfset bootstrapper.coldspringPath = arguments.coldspringPath>
		<cfset bootstrapper.coreColdspringPath = arguments.coldspringPath>
		<cfset bootstrapper.modelGlueBeanName = arguments.modelGlueBeanName>
		
		<cfset request._modelglue.bootstrap.bootstrapper = bootstrapper />
		<cfset request._modelglue.bootstrap.initializationRequest = true />
		<cfset request._modelglue.bootstrap.initializationLockPrefix = expandPath(".") & "/.modelglue" />
		<cfset request._modelglue.bootstrap.initializationLockTimeout = 60 />
		
		<cfreturn bootstrapper>
	</cffunction>
	
	<cffunction name="createModelGlueIfNotDefined" access="private">
		<cfargument name="coldspringPath" default="#this.coldspringPath#">
		<cfif isSimpleValue(mg)>
			<cfset createModelGlue(coldspringPath)>
		</cfif>
		<cfreturn mg>
	</cffunction>
	
	<cffunction name="createModelGlue" access="private">
		<cfargument name="coldspringPath" default="#this.coldspringPath#">
		<cfargument name="ShouldUseMemoized" default="false" />
		<cfif ShouldUseMemoized IS true>
			<cfset variables.mg = createBootstrapper(coldspringPath, "modelglue.MemoizedModelGlue").createModelGlue()>
		<cfelse>
			<cfset variables.mg = createBootstrapper(coldspringPath).createModelGlue()>
		</cfif>
					
		<!--- load "test" application event definitions --->
		<cfset mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML").load( mg, expandPath("/ModelGlue/gesture/test/primaryModule.xml") ) />

		<cfset request._modelglue.bootstrap.framework = mg />
		
		<cfreturn  mg>	
	</cffunction>

	
	<cffunction name="createMemoizedModelGlue" access="private">
		<cfset var coldspringPath = "/ModelGlue/gesture/module/test/ColdSpringWithMemoizedXMLModuleLoader.xml">
		<cfset variables.mg = createBootstrapper(coldspringPath, "modelglue.MemoizedModelGlue").createModelGlue( coldSpringPath )>
<!---		
		<cfdump var="#coldSpringPath#">
		<cfdump var="#variables.mg#">
		<cfdump var="#mg.getInternalBean("modelglue.ModuleLoaderFactory")#">
		<cfdump var="#mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML")#">
		<cfabort>--->
		<!--- load "test" application event definitions --->
		<cfset mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML").load( mg, expandPath("/ModelGlue/gesture/test/primaryModule.xml") ) />

		<cfset request._modelglue.bootstrap.framework = mg />
		
		<cfreturn  mg>	
	</cffunction>

</cfcomponent>
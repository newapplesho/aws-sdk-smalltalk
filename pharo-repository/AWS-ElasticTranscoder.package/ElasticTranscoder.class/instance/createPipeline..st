pipeline-Operations
createPipeline: aCreatePipelineRequestBody
	| request response |
	request := self createRequest: aCreatePipelineRequestBody url:'/2012-09-25/pipelines' method: #POST.
	response := self client request: request andOption: nil.
	^ self readJsonFromResponse: response.
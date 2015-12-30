pipeline-Operations
deletePipeline: pipelineIdString
	| request response |
	request := self createRequest: nil url: '/2012-09-25/pipelines/',pipelineIdString method: #DELETE.
	response := self client request: request andOption: nil.
	^ self readJsonFromResponse: response.
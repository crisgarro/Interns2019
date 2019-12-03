<h1 id="build-web-api-with-asp.net-net-core">Build Web API with <a href="http://Asp.Net">Asp.Net</a> (Net Core)</h1>
<h2 id="prerequisites">Prerequisites</h2>
<p>Please install the following software to complete the walkthrough</p>
<ul>
<li><a href="https://code.visualstudio.com/docs/?dv=win">Visual Studio Code</a></li>
<li><a href="https://marketplace.visualstudio.com/items?itemName=ms-vscode.csharp">CSharp for Visual Studio Code</a></li>
<li><a href="https://dotnet.microsoft.com/download/dotnet-core/3.0">.Net Core 3.0</a></li>
</ul>
<h2 id="project-creation">Project Creation</h2>
<ol>
<li>Create a new project under C:\Backend\WebApi</li>
<li>Open the integrated terminal<br>
<img src="https://i.imgur.com/VsCFaHw.png?raw=true" alt=""></li>
<li>Change the directory to C:\Backend\WebApi (use cd commands)</li>
<li>Run the following commands<pre class=" language-csharp"><code class="prism  language-csharp">dotnet <span class="token keyword">new</span> <span class="token class-name">webapi</span> <span class="token operator">-</span>o TodoApi
cd TodoApi
dotnet <span class="token keyword">add</span> package Microsoft<span class="token punctuation">.</span>EntityFrameworkCore<span class="token punctuation">.</span>SqlServer
dotnet <span class="token keyword">add</span> package Microsoft<span class="token punctuation">.</span>EntityFrameworkCore<span class="token punctuation">.</span>InMemory
code <span class="token operator">-</span>r <span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token operator">/</span>TodoApi
</code></pre>
</li>
</ol>
<p><strong>Note:</strong></p>
<blockquote>
<p>When a dialog box asks if you want to add required assets to the project, select <strong>Yes</strong>.</p>
</blockquote>
<p><strong>What this commands does?</strong></p>
<ul>
<li><strong>dotnet</strong>: used to reference the framework libraries that contains compilers and utils.</li>
<li><strong>new</strong> <em>[project type]</em>: generates a new project of the type (basic structure with sample)</li>
<li><strong>add packages</strong> <em>[package name]</em>: add packages to the existing project
<ul>
<li>SqlServer to use the libraries required</li>
<li>InMemory: To use memory databases (instead of having a real database)</li>
</ul>
</li>
<li><strong>code -r</strong> …/<em>[path]</em>: Reopens Visual Studio Code instance in the path specified.</li>
</ul>
<h2 id="run-the-project">Run the Project</h2>
<p>On Visual Studio Code, hit Cntr + F5, this should display the following dialog the <strong>first time</strong></p>
<ul>
<li>Select .Net Core<br>
<img src="https://i.imgur.com/iO7xFQI.png?raw=true" alt=""></li>
</ul>
<p>This also creates and open the file: launch.json which is used by Visual Studio Code instance to stablish  the compiler used to execute the code.</p>
<ul>
<li>Hit Cntrl + F5 one more time</li>
</ul>
<blockquote>
<p>Visual Studio will display on the terminal the execution of the project<br>
It will also launch the site: <a href="https://localhost:5001">https://localhost:5001</a></p>
</blockquote>
<p><strong>Note</strong></p>
<blockquote>
<p>If there is some certificate issue, just click Advance and allow the site to be displayed insecurely</p>
</blockquote>
<p>Now enter in the browser the Url: <a href="https://localhost:5001/WeatherForecast">https://localhost:5001/WeatherForecast</a><br>
You should see some text data in json format.</p>
<h2 id="solution-hierarchy">Solution Hierarchy</h2>
<p>Lets review the items in the created solution</p>
<p><img src="https://i.imgur.com/Ee8YrXj.png?raw=true" alt=""></p>
<ul>
<li><strong>.vscode</strong>: This is were resides the configuration to execute the project in <strong>Visual Studio Code</strong></li>
<li><strong>bin</strong>: this folder is were the executables and libraries are generated every time we compile the code</li>
<li><strong>obj</strong>: This is used to store temporally objects created during compilation or while code analysis is performed on other version of Visual Studio</li>
<li><strong>Controllers</strong>: This folder stored the controller that is basically the classes that contains the logic used in the API for each resource/verb</li>
<li><strong>Properties</strong>: This used to stored the configuration files to lauch the application
<ul>
<li><strong>launchSettings.json</strong>: Contains the information to specify the technology used to host the Web Api, ports, default urls, environment, etc.</li>
</ul>
</li>
<li><strong>appsettings.json</strong> This stored the configuration specific for the application (values used in our app by code)</li>
<li><strong>appsettings.Development.json</strong>: This is exactly the same that <strong>appsettings.json</strong> but is specific to the environment specified on the <strong>launchSettings.json</strong> file.</li>
<li><strong>Program.cs</strong>: This is our main entry point in the application</li>
<li><strong>Startup.cs</strong>: This contain the configuration for the DI (Dependency Injection) and some configuration about routing and authorization.</li>
<li><strong>TodoApi.csproj</strong> This is our project file and will specify the version of the .Net Framework used, it also includes the packages required (installed).</li>
<li><strong>WeatherForecast.cs</strong>: This is a sample class that work as a model to be returned on the WebAPI.</li>
</ul>
<h2 id="building-our-to-do-app-">Building our To-do App !</h2>
<h3 id="create-a-new-model">Create a new Model</h3>
<p>A model is a set of classes that represent the data that the app manages (resource representation)</p>
<ul>
<li>Create new folder named: <strong>Models</strong> (Right click on project structure, New Folder)</li>
<li>Add the <strong>TodoItem.cs</strong> class to the Models folder (Right click on Models Folder, New File)</li>
<li>Add the following code, which is going to create</li>
</ul>
<pre class=" language-csharp"><code class="prism  language-csharp"><span class="token keyword">namespace</span> TodoApi<span class="token punctuation">.</span>Models
<span class="token punctuation">{</span>
	<span class="token keyword">public</span> <span class="token keyword">class</span> <span class="token class-name">TodoItem</span>
	<span class="token punctuation">{</span>
		<span class="token keyword">public</span> <span class="token keyword">long</span> Id <span class="token punctuation">{</span> <span class="token keyword">get</span><span class="token punctuation">;</span> <span class="token keyword">set</span><span class="token punctuation">;</span> <span class="token punctuation">}</span>				<span class="token comment">//Unique Id</span>
		<span class="token keyword">public</span> <span class="token keyword">string</span> Name <span class="token punctuation">{</span> <span class="token keyword">get</span><span class="token punctuation">;</span> <span class="token keyword">set</span><span class="token punctuation">;</span> <span class="token punctuation">}</span>			<span class="token comment">//Name of Task</span>
		<span class="token keyword">public</span> <span class="token keyword">bool</span> IsComplete <span class="token punctuation">{</span> <span class="token keyword">get</span><span class="token punctuation">;</span> <span class="token keyword">set</span><span class="token punctuation">;</span> <span class="token punctuation">}</span>		<span class="token comment">//Status</span>
	<span class="token punctuation">}</span>
<span class="token punctuation">}</span>
</code></pre>
<p><strong>What this code does?</strong><br>
Generate a class with some properties to stored the information.</p>
<hr>
<h3 id="generating-a-database-context">Generating a Database Context</h3>
<p>The <em>database context</em> is our coordinator between Entity Framework and our app to store the data of the model.<br>
This class derived from <code>Microsoft.EntityFrameworkCore.DbContext</code></p>
<ul>
<li>Add the following class to the Models folder: <strong>TodoContext.cs</strong></li>
</ul>
<pre class=" language-csharp"><code class="prism  language-csharp"><span class="token keyword">using</span>  Microsoft<span class="token punctuation">.</span>EntityFrameworkCore<span class="token punctuation">;</span>

<span class="token keyword">namespace</span> TodoApi<span class="token punctuation">.</span>Models
<span class="token punctuation">{</span>
	<span class="token keyword">public</span> <span class="token keyword">class</span> <span class="token class-name">TodoContext</span> <span class="token punctuation">:</span> DbContext
	<span class="token punctuation">{</span>
		<span class="token keyword">public</span> <span class="token function">TodoContext</span><span class="token punctuation">(</span>DbContextOptions<span class="token operator">&lt;</span>TodoContext<span class="token operator">&gt;</span> options<span class="token punctuation">)</span>
		<span class="token punctuation">:</span> <span class="token keyword">base</span><span class="token punctuation">(</span>options<span class="token punctuation">)</span><span class="token punctuation">{</span>		<span class="token comment">//Used to call the original implementation from abstract class</span>
		<span class="token punctuation">}</span>
		
		<span class="token keyword">public</span> DbSet<span class="token operator">&lt;</span>TodoItem<span class="token operator">&gt;</span> TodoItems <span class="token punctuation">{</span> <span class="token keyword">get</span><span class="token punctuation">;</span> <span class="token keyword">set</span><span class="token punctuation">;</span> <span class="token punctuation">}</span>
	<span class="token punctuation">}</span>
<span class="token punctuation">}</span>
</code></pre>
<p><strong>What this code does?</strong><br>
Creates a TodoContext class that inherits from DbContext <em>abstract class</em> that handles the information of the TodoItem as a collection from a DatabaseSet <code>DbSet&lt;TodoItem&gt;</code></p>
<hr>
<h3 id="register-the-database-context">Register the Database Context</h3>
<p>In <a href="http://ASP.NET">ASP.NET</a> Core, services such as the DB context must be registered with the <a href="https://docs.microsoft.com/en-us/aspnet/core/fundamentals/dependency-injection?view=aspnetcore-3.0">dependency injection (DI)</a> container. The container provides the service to controllers.</p>
<ul>
<li>Update the <strong>Startup.cs</strong>:</li>
<li>Include new usings on the top section of the file<pre class=" language-csharp"><code class="prism  language-csharp"><span class="token keyword">using</span> Microsoft<span class="token punctuation">.</span>EntityFrameworkCore<span class="token punctuation">;</span>
<span class="token keyword">using</span> TodoApi<span class="token punctuation">.</span>Models<span class="token punctuation">;</span>
</code></pre>
</li>
<li>Update the ConfigureServices method to include the DbContext<pre class=" language-csharp"><code class="prism  language-csharp"><span class="token keyword">public</span> <span class="token keyword">void</span> <span class="token function">ConfigureServices</span><span class="token punctuation">(</span>IServiceCollection services<span class="token punctuation">)</span>
<span class="token punctuation">{</span>
    services<span class="token punctuation">.</span><span class="token generic-method function">AddDbContext<span class="token punctuation">&lt;</span>TodoContext<span class="token punctuation">&gt;</span></span><span class="token punctuation">(</span>opt <span class="token operator">=</span><span class="token operator">&gt;</span>
       opt<span class="token punctuation">.</span><span class="token function">UseInMemoryDatabase</span><span class="token punctuation">(</span><span class="token string">"TodoList"</span><span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">;</span>	<span class="token comment">//Memory Database, do I need to explain it?</span>
    services<span class="token punctuation">.</span><span class="token function">AddControllers</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">;</span>
<span class="token punctuation">}</span>  
</code></pre>
</li>
</ul>
<p><strong>What this code does?</strong></p>
<ul>
<li>Adds the database context to the DI container.</li>
<li>Specifies that the database context will use an in-memory database.</li>
</ul>
<hr>
<h3 id="build-our-scaffold-controller">Build our Scaffold Controller</h3>
<p>Scaffold are pre-build solution to generate code that could takes us more time (similar to templating)</p>
<ul>
<li>Run the following commands<pre class=" language-csharp"><code class="prism  language-csharp">dotnet <span class="token keyword">add</span> package Microsoft<span class="token punctuation">.</span>VisualStudio<span class="token punctuation">.</span>Web<span class="token punctuation">.</span>CodeGeneration<span class="token punctuation">.</span>Design
dotnet <span class="token keyword">add</span> package Microsoft<span class="token punctuation">.</span>EntityFrameworkCore<span class="token punctuation">.</span>Design
dotnet tool install <span class="token operator">--</span><span class="token keyword">global</span> dotnet<span class="token operator">-</span>aspnet<span class="token operator">-</span>codegenerator
dotnet aspnet<span class="token operator">-</span>codegenerator controller <span class="token operator">-</span>name TodoItemsController <span class="token operator">-</span><span class="token keyword">async</span> <span class="token operator">-</span>api <span class="token operator">-</span>m TodoItem <span class="token operator">-</span>dc TodoContext <span class="token operator">-</span>outDir Controllers
</code></pre>
</li>
</ul>
<p><strong>Note</strong></p>
<blockquote>
<p>If you get errors while executing dotnet aspnet-codegenerator, try closing and opening Visual Studio Code, this may happens since the global registry could not be detected.</p>
</blockquote>
<p><strong>What this code does?</strong></p>
<ul>
<li>Add NuGet packages required for scaffolding.</li>
<li>Installs the scaffolding engine (<code>dotnet-aspnet-codegenerator</code>).</li>
<li>Scaffolds the  <code>TodoItemsController</code>.</li>
</ul>
<h2 id="verifying-the-code">Verifying the Code</h2>
<p>Install Postman:</p>
<ul>
<li>
<p><a href="https://www.getpostman.com/downloads/">Get PostMan</a></p>
</li>
<li>
<p>Create an Account</p>
</li>
<li>
<p>Disable  <strong>SSL certificate verification</strong></p>
</li>
<li>
<p>From  <strong>File</strong>  &gt;  <strong>Settings</strong>  (<strong>General</strong>  tab), disable  <strong>SSL certificate verification</strong></p>
</li>
<li>
<p><img src="https://i.imgur.com/UbNwNNP.png?raw=true" alt=""></p>
</li>
<li>
<p>Create a New Request</p>
</li>
<li>
<p>Enter the following URL (while running the project F5)</p>
<ul>
<li><a href="https://localhost:5001/api/TodoItems">https://localhost:5001/api/TodoItems</a></li>
<li>
<blockquote>
<p>This will return [] (empty)</p>
</blockquote>
</li>
</ul>
</li>
<li>
<p>Now lets add a record</p>
</li>
<li>
<p>Change the Verb in Postman to Post</p>
</li>
<li>
<p>Go to Body, select Raw and set the format as Json</p>
</li>
<li>
<p>Input the following</p>
</li>
</ul>
<pre class=" language-json"><code class="prism  language-json"><span class="token punctuation">{</span>
  <span class="token string">"name"</span><span class="token punctuation">:</span><span class="token string">"walk dog"</span><span class="token punctuation">,</span>
  <span class="token string">"isComplete"</span><span class="token punctuation">:</span><span class="token boolean">true</span>
<span class="token punctuation">}</span>
</code></pre>
<p><img src="https://i.imgur.com/Nxsua6L.png?raw=true" alt=""></p>
<ul>
<li>Click Post</li>
<li>Now change the verb again to Get and hit send</li>
<li>You should now be able to see the results that you just posted.</li>
</ul>
<p><strong>Explore the other verbs</strong></p>


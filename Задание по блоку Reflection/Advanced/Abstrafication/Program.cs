using Abstrafication;
using System.Reflection;

try
{
    Type abstractType = typeof(AbstractClass);
    Type typeRuntimeMethodHandle = typeof(RuntimeMethodHandle);

    ConstructorInfo constructor = abstractType.GetConstructor(BindingFlags.NonPublic | BindingFlags.Instance, new Type[0]);
    MethodInfo invokeMethod = typeRuntimeMethodHandle.GetMethod("InvokeMethod", BindingFlags.Static | BindingFlags.NonPublic);
    PropertyInfo signature = constructor.GetType().GetProperty("Signature", BindingFlags.NonPublic | BindingFlags.Instance);

    var abstractClass = (AbstractClass)invokeMethod.Invoke(null, new object[] {null, null, signature.GetValue(constructor), true});

    Console.WriteLine(abstractClass.Do());
}
catch (Exception ex)
{
    Console.WriteLine(ex.ToString());
}

Console.ReadKey();


import 'fetcher.dart';
import 'memory_policy.dart';
import 'source_of_truth.dart';
import 'store.dart';
import 'store_defaults.dart';

// /**
//  * Main entry point for creating a [Store].
//  */
// @FlowPreview
// @ExperimentalCoroutinesApi
// interface StoreBuilder<Key : Any, Output : Any> {
//     fun build(): Store<Key, Output>

//     /**
//      * A store multicasts same [Output] value to many consumers (Similar to RxJava.share()), by default
//      *  [Store] will open a global scope for management of shared responses, if instead you'd like to control
//      *  the scope that sharing/multicasting happens in you can pass a @param [scope]
//      *
//      *   @param scope - scope to use for sharing
//      */
//     fun scope(scope: CoroutineScope): StoreBuilder<Key, Output>

//     /**
//      * controls eviction policy for a store cache, use [MemoryPolicy.MemoryPolicyBuilder] to configure a TTL
//      *  or size based eviction
//      *  Example: MemoryPolicy.builder().setExpireAfterWrite(10.seconds).build()
//      */
//     @ExperimentalTime
//     fun cachePolicy(memoryPolicy: MemoryPolicy<Key, Output>?): StoreBuilder<Key, Output>

//     /**
//      * by default a Store caches in memory with a default policy of max items = 100
//      */
//     fun disableCache(): StoreBuilder<Key, Output>

//     companion object {

//         /**
//          * Creates a new [StoreBuilder] from a [Fetcher].
//          *
//          * @param fetcher a [Fetcher] flow of network records.
//          */
//         @OptIn(ExperimentalTime::class)
//         fun <Key : Any, Output : Any> from(
//             fetcher: Fetcher<Key, Output>
//         ): StoreBuilder<Key, Output> = RealStoreBuilder(fetcher)

//         /**
//          * Creates a new [StoreBuilder] from a [Fetcher] and a [SourceOfTruth].
//          *
//          * @param fetcher a function for fetching a flow of network records.
//          * @param sourceOfTruth a [SourceOfTruth] for the store.
//          */
//         fun <Key : Any, Input : Any, Output : Any> from(
//             fetcher: Fetcher<Key, Input>,
//             sourceOfTruth: SourceOfTruth<Key, Input, Output>
//         ): StoreBuilder<Key, Output> = RealStoreBuilder(
//             fetcher = fetcher,
//             sourceOfTruth = sourceOfTruth
//         )
//     }
// }

// @FlowPreview
// @ExperimentalCoroutinesApi
abstract class StoreBuilder<Key, Output> {
  Store<Key, Output> build();

  // /**
  //    * A store multicasts same [Output] value to many consumers (Similar to RxJava.share()), by default
  //    *  [Store] will open a global scope for management of shared responses, if instead you'd like to control
  //    *  the scope that sharing/multicasting happens in you can pass a @param [scope]
  //    *
  //    *   @param scope - scope to use for sharing
  //    */
  // StoreBuilder<Key, Output> scope(CoroutineScope scope);

  // /**
  //    * controls eviction policy for a store cache, use [MemoryPolicy.MemoryPolicyBuilder] to configure a TTL
  //    *  or size based eviction
  //    *  Example: MemoryPolicy.builder().setExpireAfterWrite(10.seconds).build()
  //    */
  // @ExperimentalTime
  StoreBuilder<Key, Output> cachePolicy(
      MemoryPolicy<Key, Output>? memoryPolicy);

  // /**
  //    * by default a Store caches in memory with a default policy of max items = 100
  //    */
  StoreBuilder<Key, Output> disableCache();

  // companion object {

  // /**
  //        * Creates a new [StoreBuilder] from a [Fetcher].
  //        *
  //        * @param fetcher a [Fetcher] flow of network records.
  //        */
  // @OptIn(ExperimentalTime::class)
  // static StoreBuilder<Key, Output>
  //     from<Key extends Object, Output extends Object>(
  //             Fetcher<Key, Output> fetcher) =>
  //         RealStoreBuilder(fetcher);

  // /**
  //        * Creates a new [StoreBuilder] from a [Fetcher] and a [SourceOfTruth].
  //        *
  //        * @param fetcher a function for fetching a flow of network records.
  //        * @param sourceOfTruth a [SourceOfTruth] for the store.
  //        */
  static StoreBuilder<Key, Output> from<Key, Input, Output>({
    required Fetcher<Key, Input> fetcher,
    SourceOfTruth<Key, Input, Output>? sourceOfTruth,
  }) =>
      RealStoreBuilder(fetcher, sourceOfTruth);
  // }
}

// @FlowPreview
// @OptIn(ExperimentalTime::class)
// @ExperimentalCoroutinesApi
// private class RealStoreBuilder<Key : Any, Input : Any, Output : Any>(
//     private val fetcher: Fetcher<Key, Input>,
//     private val sourceOfTruth: SourceOfTruth<Key, Input, Output>? = null
// ) : StoreBuilder<Key, Output> {
//     private var scope: CoroutineScope? = null
//     private var cachePolicy: MemoryPolicy<Key, Output>? = StoreDefaults.memoryPolicy

//     override fun scope(scope: CoroutineScope): RealStoreBuilder<Key, Input, Output> {
//         this.scope = scope
//         return this
//     }

//     override fun cachePolicy(memoryPolicy: MemoryPolicy<Key, Output>?):
//         RealStoreBuilder<Key, Input, Output> {
//             cachePolicy = memoryPolicy
//             return this
//         }

//     override fun disableCache(): RealStoreBuilder<Key, Input, Output> {
//         cachePolicy = null
//         return this
//     }

//     override fun build(): Store<Key, Output> {
//         @Suppress("UNCHECKED_CAST")
//         return RealStore(
//             scope = scope ?: GlobalScope,
//             sourceOfTruth = sourceOfTruth,
//             fetcher = fetcher,
//             memoryPolicy = cachePolicy
//         )
//     }
// }

// @FlowPreview
// @OptIn(ExperimentalTime::class)
// @ExperimentalCoroutinesApi
// was : Any
class RealStoreBuilder<Key, Input, Output> extends StoreBuilder<Key, Output> {
  // CoroutineScope? _scope = null;
  MemoryPolicy<Key, Output>? cachePolicyP =
      StoreDefaults.memoryPolicy as MemoryPolicy<Key, Output>?;

  final Fetcher<Key, Input> _fetcher;
  final SourceOfTruth<Key, Input, Output>? _sourceOfTruth;

  RealStoreBuilder(
    this._fetcher, [
    this._sourceOfTruth,
  ]);

// RealStoreBuilder();

  // override fun scope(scope: CoroutineScope): RealStoreBuilder<Key, Input, Output> {
  //     this.scope = scope
  //     return this
  // }

// RealStoreBuilder<Key, Input, Output> scope(CoroutineScope scope ) {
//         this.scope = scope;
//         return this;
//     }

  // override fun cachePolicy(memoryPolicy: MemoryPolicy<Key, Output>?):
  //     RealStoreBuilder<Key, Input, Output> {
  //         cachePolicy = memoryPolicy
  //         return this
  //     }

  @override
  RealStoreBuilder<Key, Input, Output> cachePolicy(
      MemoryPolicy<Key, Output>? memoryPolicy) {
    cachePolicyP = memoryPolicy;
    return this;
  }

  RealStoreBuilder<Key, Input, Output> disableCache() {
    cachePolicyP = null;
    return this;
  }

  @override
  Store<Key, Output> build() {
    // TODO: implement build
    throw UnimplementedError();
    // return RealStore(
    //     // scope: scope ?? GlobalScope,
    //     sourceOfTruth: _sourceOfTruth,
    //     fetcher: _fetcher,
    //     memoryPolicy: cachePolicyP,
    // );
  }
}

// @FlowPreview
// @OptIn(ExperimentalTime::class)
// @ExperimentalCoroutinesApi
// class RealStoreBuilder<Key extends Object, Input extends Object, Output extends Object>
// extends StoreBuilder<Key, Output> {

//     CoroutineScope? _scope  = null;
//        MemoryPolicy<Key, Output>? _cachePolicy = StoreDefaults.memoryPolicy;

// final Fetcher<Key, Input> _fetcher;
//     final  SourceOfTruth<Key, Input, Output>? _sourceOfTruth  = null;

//     RealStoreBuilder(this._fetcher, this._sourceOfTruth);



//     override fun scope(scope: CoroutineScope): RealStoreBuilder<Key, Input, Output> {
//         this.scope = scope
//         return this
//     }

//     override fun cachePolicy(memoryPolicy: MemoryPolicy<Key, Output>?):
//         RealStoreBuilder<Key, Input, Output> {
//             cachePolicy = memoryPolicy
//             return this
//         }

//     // override fun disableCache(): RealStoreBuilder<Key, Input, Output> {
//     //     cachePolicy = null
//     //     return this
//     // }

    
//   @override
//   RealStoreBuilder<Key, Input, Output> disableCache() {
//             _cachePolicy = null;
//         return this;
//   }

//     // override fun build(): Store<Key, Output> {
//     //     @Suppress("UNCHECKED_CAST")
//     //     return RealStore(
//     //         scope = scope ?: GlobalScope,
//     //         sourceOfTruth = sourceOfTruth,
//     //         fetcher = fetcher,
//     //         memoryPolicy = cachePolicy
//     //     )
//     // }

    
//   @override
//   Store<Key, Output> build() {
//     // @Suppress("UNCHECKED_CAST")
//         return RealStore(
//             scope = scope ?: GlobalScope,
//             sourceOfTruth = sourceOfTruth,
//             fetcher = fetcher,
//             memoryPolicy = cachePolicy
//         );
//   }


// }

